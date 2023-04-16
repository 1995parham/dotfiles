#!/bin/bash

layout_yamls="$(fd .\.yaml "$HOME/.config/tmuxp")"

if [ $# -gt 0 ]; then
	# shellcheck disable=2086
	layout_yaml=$(grep "^session_name: $*\$" $layout_yamls -l)

	layout_yaml=$(basename "$layout_yaml")
	layout_name=${layout_yaml%.*}

	coproc alacritty --hold -e tmuxp load "$layout_name" >/dev/null 2>&1
elif [ $# = 0 ]; then
	# rofi first calls script without arguments to have the
	# entries.
	# shellcheck disable=2086
	layouts=$(grep 'session_name:' $layout_yamls | cut -d':' -f3)
	IFS=$'\n'
	for layout in $layouts; do
		echo "$layout"
	done
fi
