#!/usr/bin/env bash

usage() {
	echo -n 'manage large files on git'

	echo '
       _ _        _  __
  __ _(_) |_     | |/ _|___
 / _` | | __|____| | |_/ __|
| (_| | | ||_____| |  _\__ \
 \__, |_|\__|    |_|_| |___/
 |___/
  '
}

main_pre() {
	msg 'I am using git-lfs to store my books so pdfgrep is required to find the right book using its title'
}

main_apt() {
	require_apt git-lfs
}

main_pacman() {
	require_pacman git-lfs pdfgrep
}

main_brew() {
	require_brew git-lfs
}
