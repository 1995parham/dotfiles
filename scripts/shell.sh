#!/bin/bash

usage() {
	echo -n "write shell scripts with confidence using shfmt and shellcheck"
	echo '
     _          _ _
 ___| |__   ___| | |
/ __| |_ \ / _ \ | |
\__ \ | | |  __/ | |
|___/_| |_|\___|_|_|

  '
}

main_pacman() {
	require_pacman shfmt shellcheck
}

main_brew() {
	brew install shfmt
}

main_apt() {
	sudo apt install shellcheck
}
