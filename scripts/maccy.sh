#!/usr/bin/env bash

usage() {
	echo "Lightweight clipboard manager for macOS"

	# shellcheck disable=1004,2016
	echo '

 _ __ ___   __ _  ___ ___ _   _
| |_ ` _ \ / _` |/ __/ __| | | |
| | | | | | (_| | (_| (__| |_| |
|_| |_| |_|\__,_|\___\___|\__, |
                          |___/
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
	require_brew_cask maccy
}

main() {
	return 0
}

main_parham() {
	return 0
}
