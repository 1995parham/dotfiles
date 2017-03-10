# Setup python virtual environment prompt settings
VIRTUAL_ENV_DISABLE_PROMPT=true
function virtualenv_info() {
  [ $VIRTUAL_ENV ] && echo '['`python3 --version` `basename $VIRTUAL_ENV`'] '
}

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '☿' && return
  echo '○'
}

function box_name() {
  [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

function kernel_version() {
  uname -rs
}

function separator_char() {
  printf "\xee\x82\xb0"
}

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%F{blue}±"
GIT_PROMPT_PREFIX="%F{green} [%f"
GIT_PROMPT_SUFFIX="%F{green}]%f"
GIT_PROMPT_AHEAD="%F{red}ANUM%f"
GIT_PROMPT_BEHIND="%F{cyan}BNUM%f"
GIT_PROMPT_MERGING="%F{magenta}⚡︎%f"
GIT_PROMPT_UNTRACKED="%F{red}u%f"
GIT_PROMPT_MODIFIED="%F{yellow}m%f"
GIT_PROMPT_STAGED="%F{green}s%f"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
function parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

# If inside a Git repository, print its branch and state
function git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "%F{135}${git_where#(refs/heads/|tags/)}$(parse_git_state)%f"
}

function current_pwd() {
  home_replaced="$(pwd | sed -e "s,^$HOME,~,")"
  parham_git_replaced="$(printf $home_replaced | sed -e "s,^~/Documents/Git/parham,`printf "\xe2\x97\x87"`,")"
  others_git_replaced="$(printf $parham_git_replaced | sed -e "s,^~/Documents/Git/others,`printf "\xe2\x97\x86"`,")"
  go_home_replaced="$(printf $others_git_replaced | sed -e "s,^~/Documents/Go/src,`printf "\xe2\x99\xa5"`,")"
  echo $go_home_replaced
}

# Original prompt with User name and Computer name included...
# %(x.true.false) Based on the evaluation of first term of the ternary, execute the correct statement.
# '!' is true if the shell is privileged.
PROMPT='
%F{159}::%f %F{239}$(virtualenv_info)%f
%K{235} %(!.%F{199}%n%f.%F{83}%n%f) %F{208}@%f %F{38}$(box_name)%f %k%K{214}%F{235}$(separator_char)%f %F{234}$(current_pwd)%f %k%F{214}$(separator_char)%f $(git_prompt_string)
%F{123}$(prompt_char)%f '

export SPROMPT="Correct %F{red}%R%f to %F{green}%r%f [(y)es (n)o (a)bort (e)dit]? "

EPROMPT='%F{118}%@%f %F{161}$(kernel_version)%f'
RPROMPT=$EPROMPT

function zle-line-init zle-keymap-select {
  # Basically, it's just ${VARIABLE/PATTERN/REPLACEMENT}.
  # If the VARIABLE matches the PATTERN, replace it with REPLACEMENT.
  RPROMPT="%F{227}${${KEYMAP/vicmd/NORMAL}/(main|viins)/}%f $EPROMPT"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
