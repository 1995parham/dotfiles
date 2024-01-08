#!/usr/bin/env bash

usage() {
	echo "Data and model versioning"

	# shellcheck disable=1004,2016
	echo '
     _
  __| |_   _____
 / _` \ \ / / __|
| (_| |\ V / (__
 \__,_| \_/ \___|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	require_aur dvc
}

main_brew() {
	require_brew dvc
}

main() {
	return 0
}

main_parham() {
	return 0
}
