#!/bin/bash

export dependencies=(python)

usage() {
	echo -n "cowsay, but full of love ♡"

	# shellcheck disable=1004
	echo '
 _
| | _____   _____  ___  __ _ _   _
| |/ _ \ \ / / _ \/ __|/ _` | | | |
| | (_) \ V /  __/\__ \ (_| | |_| |
|_|\___/ \_/ \___||___/\__,_|\__, |
                             |___/
  '
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

main_pacman() {
	return 0
}

main() {
	python -mpip install --user --pre -U lovesay
	configfile lovesay
}
