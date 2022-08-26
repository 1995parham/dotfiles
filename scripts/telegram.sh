#!/bin/bash

usage() {
	echo -n -e "free and open source, cross-platform, cloud-based instant messaging software"

	# shellcheck disable=1004,2016
	echo '
 _       _
| |_ ___| | ___  __ _ _ __ __ _ _ __ ___
| __/ _ \ |/ _ \/ _` | |__/ _| | |_ | _ \
| ||  __/ |  __/ (_| | | | (_| | | | | | |
 \__\___|_|\___|\__, |_|  \__,_|_| |_| |_|
                |___/
  '
}

main_pacman() {
	require_pacman telegram-desktop
}

main_brew() {
	brew install --cask telegram-desktop
}
