#!/bin/bash
usage() {
	echo "Code editing. Redefined."

	# shellcheck disable=1004,2016
	echo '
               _
  ___ ___   __| | ___
 / __/ _ \ / _` |/ _ \
| (_| (_) | (_| |  __/
 \___\___/ \__,_|\___|
  '
}

main_pacman() {
	require_aur visual-studio-code-insiders-bin
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

main_parham() {
	return 0
}
