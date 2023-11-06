#!/usr/bin/env bash
set -e

# shellcheck disable=2046,2016
layout=$(
	grep 'session_name:' $(fd .\.yaml "$HOME/.config/tmuxp") | cut -d':' -f3 |
		fzf --color=fg:#ffa500,hl:#a9a9a9,prompt:#adff2f,separator:#ffe983,info:#ffe2ec \
			--preview='bat -f $(grep -l {} $(fd .\.yaml "$HOME/.config/tmuxp"))'
)

if [ -z "$layout" ]; then
	exit 1
fi

# shellcheck disable=2046
path=$(grep -l "^session_name:$layout\$" $(fd .\.yaml "$HOME/.config/tmuxp"))

if [ ! -f "$path" ]; then
	exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]] &&
	[[ "$(command -v kitty)" ]]; then
	kitty @ launch --type=tab --copy-env tmuxp load -y "$path"
else
	tmuxp load "$path"
fi
