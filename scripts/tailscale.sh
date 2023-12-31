#!/usr/bin/env bash
usage() {
	echo "Secure, remote access to eachother"

	# shellcheck disable=1004,2016
	echo '
 _        _ _               _
| |_ __ _(_) |___  ___ __ _| | ___
| __/ _` | | / __|/ __/ _` | |/ _ \
| || (_| | | \__ \ (_| (_| | |  __/
 \__\__,_|_|_|___/\___\__,_|_|\___|
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
	require_brew_cask tailscale
}

main() {
	return 0
}

main_parham() {
	return 0
}
