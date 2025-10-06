# vim:ft=zsh ts=2 sw=2 sts=2
#
# 1995parham's Theme
# Parham Alvani theme for ZSH

# Setup python virtual environment prompt settings
VIRTUAL_ENV_DISABLE_PROMPT=true
function virtualenv_info() {
  [ "$VIRTUAL_ENV" ] && echo "[  $(python3 --version) $(basename "$VIRTUAL_ENV")] "
}

function prompt_venv() {
  echo %F{239}$(virtualenv_info)%f
}

# is there any proxy?
function prompt_proxy() {
  [ "$http_proxy" ] || [ "$https_proxy" ] || [ "$ftp_proxy" ] && echo "⚔ "
}

function prompt_kube() {
  if command -v kubectl >/dev/null 2>&1; then
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2> /dev/null)
    namespace=${namespace:-default}

    local user=$(kubectl config view --minify --output 'jsonpath={..context.user}' 2> /dev/null)
    user=${user%%\/*}
    user=${user:-nobody}

    local cluster=$(kubectl config view --minify --output 'jsonpath={..context.cluster}' 2> /dev/null)
    cluster=${cluster%%:*}
    cluster=${cluster:-n/a}

    echo %F{239}'['%f %F{blue}'ﴱ'%f%F{239} "$user"@%F{216}"$cluster"%f/%F{216}"$namespace"%f%F{239}']'%f
  fi
}

function prompt_argocd() {
  if command -v argocd >/dev/null 2>&1; then
    context=$(argocd context 2> /dev/null | grep '*' | cut -d' ' -f9)

    echo %F{239}'['%f%F{216} "$context"%f%F{239}']'%f
  fi
}

function kernel_version() {
  uname -rs
}

function local_remote_prompt() {
  if [ "$SSH_CONNECTION" ]; then
    echo "⇢"
  else
    echo '@'
  fi
}

# git_prompt_info
ZSH_THEME_GIT_PROMPT_PREFIX="%F{135}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
# git_prompt_status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒%{$reset_color%}"
# git_remote_status
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%F{202}[ "
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%F{202} ]%f"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" A"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR="%F{196}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" B"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR="%F{27}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" D"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE_COLOR="%F{172}"
# vi_mode_prompt_info
MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

# replaces home by a '~' and shows only 3 component of working directory
typeset +H prompt_dir="%F{234}%3~%f "
typeset +H prompt_status=" %{$fg_bold[red]%}%(?..⍉)%f %F{cyan}%(1j.⚙.)%f"

# Original prompt with User name and Computer name included...
# %(x.true.false) Based on the evaluation of first term of the ternary, execute the correct statement.
# '!' is true if the shell is privileged.
PROMPT='
%F{159}::%f $(prompt_argocd)%f
%F{159}::%f$(prompt_venv) $(prompt_kube) %F{75}${CONDA_DEFAULT_ENV:+ $CONDA_DEFAULT_ENV}%f
┌ %K{235}${prompt_status} %(!.%F{199}%n%f.%F{83}%n%f) %F{208}$(local_remote_prompt)%f %F{38}%M%f %k%K{214} ${prompt_dir} %k $(git_prompt_info) $(git_prompt_status) $(git_remote_status)
└ %F{123}○%f $(prompt_proxy)'

PROMPT2='%{%(!.%F{red}.%F{white})%}◀%{$reset_color%} '

RPROMPT='$(vi_mode_prompt_info) %F{118}%@%f %F{161}$(kernel_version)%f'
