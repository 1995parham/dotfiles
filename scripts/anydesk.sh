#!/usr/bin/env bash
usage() {
	echo "AnyDesk is a software that enables you to access and control devices remotely from anywhere in the world."

	# shellcheck disable=1004,2016
	echo '
                       _           _
  __ _ _ __  _   _  __| | ___  ___| | __
 / _` | |_ \| | | |/ _` |/ _ \/ __| |/ /
| (_| | | | | |_| | (_| |  __/\__ \   <
 \__,_|_| |_|\__, |\__,_|\___||___/_|\_\
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
	require_brew_cask anydesk
}

main() {
	return 0
}

main_parham() {
	return 0
}
