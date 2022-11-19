#!/bin/bash

usage() {
	echo -n -e "Zig is a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."

	# shellcheck disable=1004,2016
	echo '
     _
 ___(_) __ _
|_  / |/ _` |
 / /| | (_| |
/___|_|\__, |
       |___/
  '
}

main_pacman() {
	require_pacman zig
}

main_brew() {
	require_brew zig
}
