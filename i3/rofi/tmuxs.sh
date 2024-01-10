#!/bin/bash

if [ $# = 1 ]; then
	coproc alacritty -e tmux attach -t "${1%%:*}"
elif [ $# = 0 ]; then
	# rofi first calls script without arguments to have the
	# entries.
	tmux list-sessions
fi
