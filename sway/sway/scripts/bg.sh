#!/bin/bash

set -eu

# kill the current swaybg process
pkill -e swaybg || true

_end() {
	echo "see you in a better tomorrow [you signal start.sh execuation]"
	pkill swaybg
	exit
}

main() {
	trap '_end' INT TERM
	shift

	local -A old_pid
	local -A new_pid

	while true; do
		for output in $(swaymsg -t get_outputs -r | jq '.[].name ' -r); do
			swaybg -o "$output" -i "$(find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg | shuf --random-source=/dev/random -n1)" -m fill &
			new_pid[$output]=$!
			sleep 5
			if [ "${old_pid[$output]+abc}" ]; then
				kill "${old_pid[$output]}"
			fi
			old_pid[$output]=${new_pid[$output]}
		done
		sleep 5
	done
}

fork() {
	echo 'is there any other bg.sh living there?'
	bg_process_count=$(pgrep -c bg.sh)
	while [ "$bg_process_count" -gt 1 ]; do
		echo "there are more that 1 bg process is living there, lets killing them"

		pkill -eo bg.sh
		bg_process_count=$(pgrep -c bg.sh)
	done

	echo 'creating a new fork'
	# based on https://unix.stackexchange.com/a/435582/538843
	nohup setsid "$0" daemon "$@" &>/dev/null &
}

if [ $# -ge 1 ] && [ "$1" = "daemon" ]; then
	main "$@"
else
	fork "$@"
fi
