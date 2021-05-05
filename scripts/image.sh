#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : image.sh
#
# [] Creation Date : 05-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "image manipulation tools including: imagemagick (convert), gimp"
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm gimp imagemagick
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
