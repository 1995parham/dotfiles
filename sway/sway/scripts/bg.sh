#!/bin/bash

set -euo pipefail

# kill the current swaybg process
pkill -e swaybg || true

_end() {
	echo "see you in a better tomorrow [you signal bg.sh die]"
	pkill swaybg || true
	exit
}

set_bg() {
	output=$1
	swaybg -o "$output" -i \
		"$(
			find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg |
				shuf -n1
		)" \
		-m fill &
}

get_outputs() {
	swaymsg -t get_outputs -r | jq '.[].name ' -r
}

main() {
	trap '_end' INT TERM

	local -A old_pid
	local -A new_pid

	for output in $(get_outputs); do
		set_bg "$output"
		old_pid[$output]=$!
	done

	while true; do
		for output in $(get_outputs); do
			set_bg "$output"
			new_pid[$output]=$!
			sleep 5
			kill "${old_pid[$output]}"
			old_pid[$output]=${new_pid[$output]}
		done
		sleep 5
	done
}

main "$@"
