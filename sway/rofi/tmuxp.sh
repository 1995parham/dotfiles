#!/bin/bash

declare -A muxes

muxes=(
	["Learning"]="learning"
	["Snapp"]="snapp"
	["Offerland"]="offerland"
	["1995parham-me"]="1995parham"
	["Teaching"]="teaching"
	["Main"]="main"
	["Raha"]="raha"
	["Task"]="task"
	["Research"]="research"
)

if [ $# = 1 ]; then
	coproc alacritty -e tmuxp load "${muxes[$1]}" >/dev/null 2>&1
elif [ $# = 0 ]; then
	# rofi first calls script without arguments to have the
	# entries.
	for mux in "${!muxes[@]}"; do
		echo "$mux"
	done
fi
