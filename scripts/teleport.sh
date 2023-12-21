#!/usr/bin/env bash
usage() {
	echo "The Open Infrastructure Access Platform"

	# shellcheck disable=1004,2016
	echo '
 _       _                       _
| |_ ___| | ___ _ __   ___  _ __| |_
| __/ _ \ |/ _ \ |_ \ / _ \| |__| __|
| ||  __/ |  __/ |_) | (_) | |  | |_
 \__\___|_|\___| .__/ \___/|_|   \__|
               |_|
  '
}

main_pacman() {
	require_aur teleport-bin
}

main_brew() {
	require_brew teleport
}
