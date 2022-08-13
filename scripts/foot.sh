#!/bin/bash

usage() {
	echo -n "A fast, lightweight and minimalistic wayland terminal emulator"
	# shellcheck disable=2016
	echo '
  __             _
 / _| ___   ___ | |_
| |_ / _ \ / _ \| __|
|  _| (_) | (_) | |_
|_|  \___/ \___/ \__|

	'
}

main_pacman() {
	require_pacman foot
}

main() {
	configfile foot
}
