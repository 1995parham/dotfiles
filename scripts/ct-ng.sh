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
	echo -n -e "crosstool-ng to compile what we needs as an embedded developer"

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
	sudo pacman -Syu --needed --noconfirm help2man
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	mkdir "$HOME/.cache" || true
	cd "$HOME/.cache" || exit
	git clone https://github.com/crosstool-ng/crosstool-ng || true
	cd crosstool-ng || exit
	./bootstrap
	./configure --prefix="/usr/local"
	make
	sudo make install

	# mkdir "$HOME/src" || true
	# HACK until crosstool-ng has fixed its mirror for isl library
	# cd "$HOME/src" && aria2c https://libisl.sourceforge.io/isl-0.20.tar.gz
	# cd "$HOME/src" && aria2c https://github.com/libexpat/libexpat/releases/download/R_2_2_6/expat-2.2.6.tar.bz2
}
