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
	echo "def, a free dictionary in terminal"
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm sdcv
	yay -Syu --needed --noconfirm stardict-oald
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}
