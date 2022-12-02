#!/bin/bash

usage() {
	echo -n "a very fast implementation of tldr in rust"
	# shellcheck disable=2016
	echo '
 _             _     _
| |_ ___  __ _| | __| | ___  ___ _ __
| __/ _ \/ _| | |/ _| |/ _ \/ _ \ |__|
| ||  __/ (_| | | (_| |  __/  __/ |
 \__\___|\__,_|_|\__,_|\___|\___|_|
	'
}

main_pacman() {
	require_pacman tealdeer
}

main() {
	tldr --update
}
