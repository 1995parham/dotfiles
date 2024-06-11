#!/usr/bin/env bash
usage() {
	echo "All the user-friendliness of our Terminal version, now wrapped up in a sleek graphical interface."

	# shellcheck disable=1004,2016
	echo '
 _     _   _         _
| |__ | |_| |_ _ __ (_) ___
| |_ \| __| __| |_ \| |/ _ \
| | | | |_| |_| |_) | |  __/
|_| |_|\__|\__| .__/|_|\___|
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
	require_brew_cask httpie
}

main() {
	return 0
}

main_parham() {
	return 0
}
