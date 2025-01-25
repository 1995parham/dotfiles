#!/usr/bin/env bash
set -e

# shellcheck disable=2046,2016
layout=$(
    grep 'session_name:' $(fd .\.yaml "$HOME/.config/tmuxp") | cut -d':' -f3 | awk '{$1=$1;print}' |
        fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
            --preview='bat -f $(grep -l {} $(fd .\.yaml "$HOME/.config/tmuxp"))'
)

if [ -z "$layout" ]; then
    exit 1
fi

# shellcheck disable=2046
path=$(grep -l "^session_name: $layout\$" $(fd .\.yaml "$HOME/.config/tmuxp"))

if [ ! -f "$path" ]; then
    exit 1
fi

# using commands are better because tmux can be share between different
# terminal emulators and this will mess up the environment variables.
if [[ "${OSTYPE}" == "darwin"* ]]; then
    bash="$(which bash)"

    if [[ -n "$(command -v wezterm)" ]]; then
        echo "tmuxp load $path -y -d && tmux a -t '$layout'"
        wezterm cli spawn -- "$bash" -ilc "tmuxp load $path -y -d && tmux a -t '$layout'"
    fi
else
    tmuxp load "$path"
fi
