#!/bin/bash

usage() {
	echo -n -e "u-mamba for machine learning and data science"

	# shellcheck disable=1004,2016
	echo '
                           _
 _ __ ___   __ _ _ __ ___ | |__   __ _
| |_ | _ \ / _| | |_ | _ \| |_ \ / _| |
| | | | | | (_| | | | | | | |_) | (_| |
|_| |_| |_|\__,_|_| |_| |_|_.__/ \__,_|

  '
}

main_pacman() {
	require_aur micromamba
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

main() {
	dotfile mamba mambarc
}
