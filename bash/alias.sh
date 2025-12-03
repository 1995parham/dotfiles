#!/usr/bin/env bash

DOTFILES_ROOT=${DOTFILES_ROOT:?"dotfiles root must be set for using aliases"}

# shellcheck source=./scripts/lib/main.sh
source "$DOTFILES_ROOT/scripts/lib/main.sh"

if [ -d "$HOME/.config/aliases" ]; then
    if [ ! -f "$HOME/.config/aliases/kubectl_aliases.sh" ]; then
        curl -#L https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases >"$HOME/.config/aliases/kubectl_aliases.sh"
    fi

    # shellcheck disable=1090
    for f in "$HOME"/.config/aliases/*.sh; do
        # message 'aliases' "sourcing $f"
        source "$f"
    done
fi

# set personal aliases
# for a full list of active aliases, run `alias`.

# check the weather using wttr.in
function wea() {
    local request="wttr.in/${1-Tehran}?Fqm"
    [ "$(tput cols)" -lt 125 ] && request+='n'
    curl -H "Accept-Language: en" --compressed "$request"
}

# tehran weather in one line
alias wea1='curl -s "wttr.in/{Miami,Austin,Tehran}?format=3&m"'
# current weather in tehran
alias weac='curl -s "wttr.in/Tehran?F0m"'
# 3 day forecast in tehran
alias weaf='curl -s "wttr.in/Tehran?Fqm"'

# watch network connection
alias nw='watch -n 3 -t -d -b "curl -s https://myip.wtf/json"'

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias imv="open"
    alias ls="ls --color"
    alias mupdf="open"
    alias wl-copy=pbcopy
    alias wl-paste=pbpaste
    alias mtr="sudo mtr"
    alias python=python3
    alias mcli=mc
fi

alias grep="grep --color=auto"
alias vi="vim"
alias ls-la="ls --color -la"
alias l="ls -la --color"
function ls-() {
    local first_arg="-$1"
    shift
    command ls --color "$first_arg" "$@"
}

