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
	trap '_end' INT
	shift

	local old_pid=""
	local new_pid=""

	while true; do
		swaybg -i "$(find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg | shuf -n1)" -m fill &
		new_pid=$!
		sleep 5
		if [ -n "$old_pid" ]; then
			kill "$old_pid"
		fi
		old_pid=$new_pid
		sleep 50
	done
}

fork() {
	echo 'is there anyother bg living there?'
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

if [ $# -ge 1 ] && [ "$1" == "daemon" ]; then
	main "$@"
else
	fork "$@"
fi
