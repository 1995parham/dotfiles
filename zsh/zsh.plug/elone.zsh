#!/bin/zsh
# In The Name of God
# ========================================
# [] File Name : elone.zsh
#
# [] Creation Date : 28-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# Do not load anything if git is not available.
if (( ! $+commands[git] )); then
    echo 'ELone: Please install git to use ELone.' >&2
    return 1
fi

# Each line in this string has the following entries separated by a space
# character.
# <repo-url>, <plugin-name>, <bundle-type>, <plugin-location>
typeset -aU _ELONE_BUNDLE_RECORD

# A syntax sugar to avoid the `-` when calling elone commands. With this
# function, you can write `elone-bundle` as `elone bundle` and so on.
elone () {
  local cmd="$1"
  if [[ -z "$cmd" ]]; then
    elone-help >&2
    return 1
  fi
  shift
  if (( $+functions[elone-$cmd] )); then
      "elone-$cmd" "$@"
      return $?
  else
      echo "ELone: Unknown command: $cmd" >&2
      return 1
  fi
}

# Parses and retrieves a remote branch given a branch name.
#
# If the branch name contains '*' it will retrieve remote branches
# and try to match against tags and heads, returning the latest matching.
#
# Usage
#     -elone-parse-branch https://github.com/user/repo.git x.y.z
#
# Returns
#     Branch name
-elone-parse-branch () {
  local url="$1" branch="$2" branches

  local match mbegin mend MATCH MBEGIN MEND

  if [[ "$branch" =~ '\*' ]]; then
    branches=$(git ls-remote --tags -q "$url" "$branch"|cut -d'/' -f3|sort -n|tail -1)
    # There is no --refs flag in git 1.8 and below, this way we
    # emulate this flag -- also git 1.8 ref order is undefined.
    branch=${${branches#*/*/}%^*} # Why you are like this?
  fi

  echo $branch
}


# Ensure that a clone exists for the given repo url and branch. If the first
# argument is `update` and if a clone already exists for the given repo
# and branch, it is pull-ed, i.e., updated.
#
# This function expects three arguments in order:
# - 'url=<url>'
# - 'clone_dir=<clone_dir>'
# - 'update=true|false'
# - 'verbose=true|false'
#
# Returns true|false Whether cloning/pulling was succesful
-elone-ensure-repo () {
  if (( $# < 2 )); then
    echo "ELone: Missing url or name argument."
    return 1
  fi

  # The url. No sane default for this, so just empty.
  local url=$1
  # The clone directory
  local clone_dir=$2
  # Check if we have to update.
  local update=${2:-false}
  # Verbose output.
  local verbose=${3:-false}

  shift $#

  if [[ -d "$clone_dir" && $update == false ]]; then
    return true
  fi

  # A temporary function wrapping the `git` command with repeated arguments.
  --plugin-git () {
    (\cd -q "$clone_dir" && eval ${ELONE_CLONE_ENV} git --git-dir="$clone_dir/.git" --no-pager "$@" &>>! $ELONE_LOG)
  }

  local success=false

  # If its a specific branch that we want, checkout that branch.
  local branch="master" # TODO FIX THIS
  if [[ $url == *\|* ]]; then
     branch="$(-elone-parse-branch ${url%|*} ${url#*|})"
  fi

  if [[ ! -d $clone_dir ]]; then
    eval ${ELONE_CLONE_ENV} git clone ${=ELONE_CLONE_OPTS} --branch "$branch" -- "${url%|*}" "$clone_dir" &>> $ELONE_LOG
    success=$?
  elif $update; then
    # Save current revision.
    local old_rev="$(--plugin-git rev-parse HEAD)"
    # Pull changes if update requested.
    --plugin-git checkout "$branch"
    --plugin-git pull origin "$branch"
    success=$?

    # Update submodules.
    --plugin-git submodule update ${=ELONE_SUBMODULE_OPTS}
    # Get the new revision.
    local new_rev="$(--plugin-git rev-parse HEAD)"
  fi

  if [[ -n $old_rev && $old_rev != $new_rev ]]; then
    echo Updated from $old_rev[0,7] to $new_rev[0,7].
    if $verbose; then
      --plugin-git log --oneline --reverse --no-merges --stat '@{1}..'
    fi
  fi

  # Remove the temporary git wrapper function.
  unfunction -- --plugin-git

  return $success
}

#
# Usage:
#   -elone-bundle-install <record>
# Returns:
#   1 if it fails to install bundle
-elone-bundle-install () {
  typeset -A bundle; bundle=($@)

  # Clone if it doesn't already exist.
  local start=$(date +'%s')

  printf "Installing %s from %s... " "${bundle[name]}" "${bundle[url]}"

  if ! -elone-ensure-repo ${bundle[url]} ${bundle[dir]}; then
    # Return immediately if there is an error cloning
    printf "Error! ...\n" >&2
    return 1
  fi

  local took=$(( $(date +'%s') - $start ))
  printf "Done. Took %ds.\n" $took
}

# Syntaxes
#   elone-bundle <url> <name> <type>
elone-bundle () {
  if (( $# < 2 )); then
    printf "ELone: Must provide a bundle url, name and [type]\n" >&2
    return 1
  fi

  builtin typeset -A bundle;

  local url="$1"
  if [[ $url != git://* &&
          $url != https://* &&
          $url != http://* &&
          $url != ssh://* &&
          $url != /* &&
          $url != *github.com:*/*
          ]]; then
    url="https://github.com/${url%.git}.git"
  fi
  bundle[url]="$url"

  bundle[name]="$2"

  local btype="$3"
  if [[ $btype != "plugins" &&
          $btype != "themes"
          ]]; then
    btype="plugins"
  fi
  bundle[btype]="$btype"

  bundle[dir]="$ZSH_CUSTOM/${bundle[btype]}/${bundle[name]}"

  local record="${bundle[url]} ${bundle[name]} ${bundle[btype]} ${bundle[dir]}"
  if [[ ! ${_ELONE_BUNDLE_RECORD[(I)$record]} == 0 ]]; then
    printf "Seems %s is already installed from %s!\n" ${bundle[name]} ${bundle[url]}
    return 1
  fi

  # Clone bundle if we haven't done do already.
  if [[ ! -d "${bundle[dir]}" ]]; then
    if ! -elone-bundle-install ${(kv)bundle}; then
      return 1
    fi
  fi

  # Only add it to the record if it could be installed.
  _ELONE_BUNDLE_RECORD+=("$record")
  if [[ $btype == "plugins" ]]; then
    plugins+=("${bundle[name]}")
  fi
}

# Updates a bundle performing a `git pull`.
#
# Usage
#    -elone-update-bundle <record>
#
# Returns
#    Nothing. Performs a `git pull`.
-elone-bundle-update () {
  typeset -A bundle; bundle=($@)
  local start=$(date +'%s')

  if [[ $# -eq 0 ]]; then
    printf "ELone: Missing argument.\n" >&2
    return 1
  fi

  printf "Updating %s from %s... " "${bundle[name]}" "${bundle[url]}"

  # update=true verbose=false
  if ! -elone-ensure-repo ${bundle[url]} ${bundle[dir]} true false; then
    printf "Error! ...\n" >&2
    return 1
  fi

  local took=$(( $(date +'%s') - $start ))
  printf "Done. Took %ds.\n" $took
}


# Install oh-my-zsh
#
# Usage
#     elone-oh
#
elone-oh () {
  builtin typeset -A bundle
  bundle[url]="https://github.com/robbyrussell/oh-my-zsh.git"
  bundle[name]="rubbyrussell/oh-my-zsh"
  bundle[dir]="$ZSH"

  if [ ! -d $ZSH ]; then
     if ! -elone-bundle-install ${(kv)bundle}; then
       printf "ELone: oh failed, lets run away"
       return 1
     fi
  fi
}

# List instaled bundles.
#
# Usage
#    elone-list
#
# Returns
#    List of bundles
elone-list () {
  local record bundle

  # List all currently installed bundles.
  if [[ -z $_ELONE_BUNDLE_RECORD ]]; then
    echo "You don't have any bundles." >&2
    return 1
  fi

  for record in $_ELONE_BUNDLE_RECORD; do
    bundle=(${(@s/ /)record})
    printf "\nplugin-name: %s\nplugin-location: %s\nbundle-type: %s\nrepo-url: %s\n" $bundle[2] $bundle[4] $bundle[3] $bundle[1]
  done
}

# Updates the bundles.
#
# Usage
#    elone-update
#
# Returns
#    Nothing. Performs a `git pull`.
elone-update () {
  local record bundle

  for record in $_ELONE_BUNDLE_RECORD; do
    record=(${(@s/ /)record})

    builtin typeset -A bundle
    bundle[name]=$record[2]
    bundle[dir]=$record[4]
    bundle[btype]=$record[3]
    bundle[url]=$record[1]

    if ! -elone-bundle-update ${(kv)bundle}; then
      return 1
    fi

  done
  cd -
}

# Helper function: Same as `$1=$2`, but will only happen if the name
# specified by `$1` is not already set.
-elone-set-default () {
  local arg_name="$1"
  local arg_value="$2"
  eval "test -z \"\$$arg_name\" && typeset -g $arg_name='$arg_value'"
}

-elone-set-default ELONE_LOG /dev/null

# CLONE_OPTS uses ${=CLONE_OPTS} expansion so don't use spaces
# for arguments that can be passed as `--key=value`.
-elone-set-default ELONE_CLONE_ENV "GIT_TERMINAL_PROMPT=0"
-elone-set-default ELONE_CLONE_OPTS "--single-branch --recursive --depth=1"
-elone-set-default ELONE_SUBMODULE_OPTS "--recursive --depth=1"


elone-version () {
  printf "ELone: %s (%s)\n" "dotfiles-master" "HEAD"
}

elone-help () {
  elone-version

  cat <<EOF
ELone is a plugin management system for oh-my-zsh. It makes it easy to grab awesome
oh-my-zsh plugins and utilities, put up on Github.
Usage: elone <command> [args]
Commands:
  bundle       Install a plugin.
  list         List currently installed plugins.
  purge        Remove a bundle from the filesystem.
  update       Update plugins.
  oh           Install oh-my-zsh.
EOF
}
