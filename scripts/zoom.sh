#!/usr/bin/env bash
usage() {
	echo "Zoom is a communications platform that allows users to connect with video, audio, phone, and chat."

	# shellcheck disable=1004,2016
	echo '

 _______   ___  _ __ ___
|_  / _ \ / _ \| |_ ` _ \
 / / (_) | (_) | | | | | |
/___\___/ \___/|_| |_| |_|
  '
}

pre_main() {
	return 0
}

main_pacman() {
	require_aur zoom
}

main_brew() {
	require_brew_cask zoom
}

main() {
	return 0
}

main_parham() {
	return 0
}
