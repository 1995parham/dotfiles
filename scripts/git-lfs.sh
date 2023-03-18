#!/bin/bash

usage() {
	echo -n 'manage large files on git'

	# shellcheck disable=1004,2016
	echo '
       _ _        _  __
  __ _(_) |_     | |/ _|___
 / _` | | __|____| | |_/ __|
| (_| | | ||_____| |  _\__ \
 \__, |_|\__|    |_|_| |___/
 |___/
  '
}

main_apt() {
	sudo apt install git-lfs
}

main_pacman() {
	msg 'i am using git-lfs to store my papers so pdfgrep is required to find the right paper'
	sudo pacman -Syu --needed --noconfirm git-lfs pdfgrep
}

main_brew() {
	brew install git-lfs
}

main() {
	msg 'setup lfs on your account'

	git lfs install
}
