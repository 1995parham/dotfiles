#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : ct-ng.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "crosstool-ng to compile what we needs as embedded developer"

	# shellcheck disable=1004,2016
	echo '
      _
  ___| |_      _ __   __ _
 / __| __|____| |_ \ / _` |
| (__| ||_____| | | | (_| |
 \___|\__|    |_| |_|\__, |
                     |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Rsu crosstool-ng
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	mkdir "$HOME/src"

	# HACK until crosstool-ng has fixed its mirror for isl library
	cd "$HOME/src" && wget ftp.halifax.rwth-aachen.de/gentoo/distfiles/isl-0.24.tar.xz
}
