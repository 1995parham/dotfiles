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

	while true; do
		swaybg -i "$(find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg | shuf -n1)" -m fill &
		local new_pid=$!
		sleep 5
		if [ -n "$old_pid" ]; then
			kill "$old_pid"
		fi
		local old_pid=$new_pid
		sleep 50
	done
}

fork() {
	echo 'creating a new fork'
	# based on https://unix.stackexchange.com/a/435582/538843
	nohup setsid "$0" daemon "$@" &>/dev/null &
}

if [ $# -ge 1 ] && [ "$1" == "daemon" ]; then
	main "$@"
else
	fork "$@"
fi
