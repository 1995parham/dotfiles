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

# using commands are better because tmux can be share between different
# terminal emulators and this will mess up the environment variables.
if [[ -n "$(command -v wezterm)" ]]; then
	pane_id=$(wezterm cli spawn)
	wezterm cli send-text --pane-id "${pane_id}" "$(printf "%s\r" "tmuxp load $path")"
	wezterm cli activate-pane --pane-id "${pane_id}"
else
	tmuxp load "$path"
fi
