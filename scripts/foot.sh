#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : alacritty.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "A fast, lightweight and minimalistic Wayland terminal emulator"
	# shellcheck disable=2016
	echo '
  __             _
 / _| ___   ___ | |_
| |_ / _ \ / _ \| __|
|  _| (_) | (_) | |_
|_|  \___/ \___/ \__|

	'
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed foot
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	configfile foot
}
