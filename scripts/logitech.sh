#!/bin/bash
usage() {
	echo "Logitech International S.A. is a Swiss-American multinational manufacturer of computer peripherals and software, with headquarters in Lausanne, Switzerland, and Newark, California."

	# shellcheck disable=1004,2016
	echo '
 _             _ _            _
| | ___   __ _(_) |_ ___  ___| |__
| |/ _ \ / _` | | __/ _ \/ __| |_ \
| | (_) | (_| | | ||  __/ (__| | | |
|_|\___/ \__, |_|\__\___|\___|_| |_|
         |___/
  '
}

main_pacman() {
	require_pacman solaar
	msg 'use ( xhost +si:localuser:root ) on wayland before running it because it needs sudo permission to run'
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

main_parham() {
	return 0
}
