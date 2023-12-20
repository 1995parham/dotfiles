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
	require_brew teleport
}

main() {
	return 0
}

main_parham() {
	return 0
}
