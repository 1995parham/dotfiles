#!/usr/bin/env bash
usage() {
	echo "Imagine a place..."

	# shellcheck disable=1004,2016
	echo '
     _ _                       _
  __| (_)___  ___ ___  _ __ __| |
 / _` | / __|/ __/ _ \| |__/ _` |
| (_| | \__ \ (_| (_) | | | (_| |
 \__,_|_|___/\___\___/|_|  \__,_|
  '
}

main_pacman() {
	require_aur webcord
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}
