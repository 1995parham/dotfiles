#!/bin/bash
usage() {
	echo "Portal is a quick and easy command-line file transfer utility from any computer to another"

	# shellcheck disable=1004,2016
	echo '
                  _        _
 _ __   ___  _ __| |_ __ _| |
| |_ \ / _ \| |__| __/ _` | |
| |_) | (_) | |  | || (_| | |
| .__/ \___/|_|   \__\__,_|_|
|_|
  '
}

main_pacman() {
	require_aur portal-bin
}

main() {
	return 0
}

main_parham() {
	return 0
}
