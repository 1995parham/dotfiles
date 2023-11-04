#!/usr/bin/env bash
usage() {
	echo "Postman is an API platform for building and using APIs"

	# shellcheck disable=1004,2016
	echo '
                 _
 _ __   ___  ___| |_ _ __ ___   __ _ _ __
| |_ \ / _ \/ __| __| |_ ` _ \ / _` | |_ \
| |_) | (_) \__ \ |_| | | | | | (_| | | | |
| .__/ \___/|___/\__|_| |_| |_|\__,_|_| |_|
|_|
  '
}

main_pacman() {
	require_aur postman-bin
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
