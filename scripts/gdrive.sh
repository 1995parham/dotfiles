#!/usr/bin/env bash
usage() {
	echo "Google Drive CLI Client"

	# shellcheck disable=1004,2016
	echo '
           _      _
  __ _  __| |_ __(_)_   _____
 / _` |/ _` | |__| \ \ / / _ \
| (_| | (_| | |  | |\ V /  __/
 \__, |\__,_|_|  |_| \_/ \___|
 |___/
  '
}

export dependencies=("rust")

main_pacman() {
	require_aur gdrive
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
