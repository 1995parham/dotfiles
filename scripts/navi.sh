#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "navi cheatsheet"
}

main_brew() {

	brew install navi
}

main_apt() {
	return -1
}

main_pacman() {

	yay -Syu --noconfirm --needed navi-bin
}

main() {
	navi repo add 1995parham/cheats
}
