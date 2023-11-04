#!/usr/bin/env bash
usage() {
	echo "The easy way to design, debug, and test APIs"

	# shellcheck disable=1004,2016
	echo '
 _                                 _
(_)_ __  ___  ___  _ __ ___  _ __ (_) __ _
| | |_ \/ __|/ _ \| |_ ` _ \| |_ \| |/ _` |
| | | | \__ \ (_) | | | | | | | | | | (_| |
|_|_| |_|___/\___/|_| |_| |_|_| |_|_|\__,_|
  '
}

main_pacman() {
	require_aur insomnia
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
