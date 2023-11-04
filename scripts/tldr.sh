#!/usr/bin/env bash

usage() {
	echo -n "too long; didn't read"
	# shellcheck disable=2016
	echo '
 _   _     _
| |_| | __| |_ __
| __| |/ _| | |__|
| |_| | (_| | |
 \__|_|\__,_|_|
	'
}

main_pacman() {
	require_pacman tealdeer
}

main_brew() {
	require_brew tldr
}

main() {
	tldr --update
}
