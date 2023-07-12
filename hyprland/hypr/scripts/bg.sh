#!/bin/bash

set -eu

_end() {
	echo "see you in a better tomorrow [you signal start.sh execuation]"
	exit
}

main() {
	trap '_end' INT TERM
	shift
	local pic=""
	local old_pic=""

	while true; do
		for output in $(hyprctl monitors -j | jq '.[].name ' -r); do
			echo "setting wallpaper on $output"
			if [ -n "$pic" ]; then
				old_pic="$pic"
			fi
			pic="$(find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg | shuf --random-source=/dev/random -n1)"
			echo "$pic is selected as the new wallpaper"
			hyprctl hyprpaper preload "$pic"
			hyprctl hyprpaper wallpaper "$output,$pic"
			if [ -n "$old_pic" ]; then
				hyprctl hyprpaper unload "$old_pic"
			fi
			sleep 5
		done
	done
}

fork() {
	echo 'creating a new fork'
	# based on https://unix.stackexchange.com/a/435582/538843
	nohup setsid "$0" daemon "$@" &>/dev/null &
}

if [ $# -ge 1 ] && [ "$1" = "daemon" ]; then
	main "$@"
else
	fork "$@"
fi
