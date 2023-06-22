#!/bin/bash

usage() {
	echo "sharpen your thinking"

	# shellcheck disable=1004,2016
	echo '
       _         _     _ _
  ___ | |__  ___(_) __| (_) __ _ _ __
 / _ \| |_ \/ __| |/ _| | |/ _| | |_ \
| (_) | |_) \__ \ | (_| | | (_| | | | |
 \___/|_.__/|___/_|\__,_|_|\__,_|_| |_|

  '
}

main_pacman() {
	require_pacman obsidian
}

main() {
	return 0
}
