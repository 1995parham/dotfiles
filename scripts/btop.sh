#!/bin/bash

usage() {
	echo -n "a monitor of resources"
	# shellcheck disable=2016
	echo '
 _     _
| |__ | |_ ___  _ __
| |_ \| __/ _ \| |_ \
| |_) | || (_) | |_) |
|_.__/ \__\___/| .__/
               |_|
	'
}

main_brew() {
	require_brew btop
}

main_pacman() {
	require_pacman btop
}

main_apt() {
	require_apt btop
}

main() {
	configfile btop
}
