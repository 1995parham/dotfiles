#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : btop.sh
#
# [] Creation Date : 12-07-2022
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "A monitor of resources"
	# shellcheck disable=2016
	echo '
 _     _
| |__ | |_ ___  _ __
| |_ \| __/ _ \| |_ \
| |_) | || (_) | |_) |
|_.__/ \__\___/| .__/
               |_|
	'
}

main_brew() {
	brew install btop
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed btop
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	configfile btop
}
