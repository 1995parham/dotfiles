#!/usr/bin/env bash

usage() {
	echo "cmus is a small, fast and powerful console music player for Unix-like operating systems."

	# shellcheck disable=1004,2016
	echo '

  ___ _ __ ___  _   _ ___
 / __| |_ ` _ \| | | / __|
| (__| | | | | | |_| \__ \
 \___|_| |_| |_|\__,_|___/
  '
}

pre_main() {
	return 0
}

main_pacman() {
	return 1
}

main_apt() {
	return 1
}

main_brew() {
	require_brew cmus
}

main() {
	configfile cmus
}

main_parham() {
	return 0
}
