#!/bin/bash

usage() {
	echo "assembly development tools (nasm, rizin etc.)"

	# shellcheck disable=2016,1004
	echo '
  __ _ ___ _ __ ___
 / _` / __| |_ ` _ \
| (_| \__ \ | | | | |
 \__,_|___/_| |_| |_|

  '
}

main_pacman() {
	require_pacman nasm rizin rz-cutter
}
