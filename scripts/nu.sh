#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : nu.sh
#
# [] Creation Date : 02-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "brand new shell in rust, give it a try"
}

main_apt() {
	msg "there is nothing that we can do"
	return -1
}

main_brew() {
	brew install nushell starship
}

main_pacman() {
	yay -Syu --noconfirm --needed nushell-bin
	sudo pacman -Syu --noconfirm --needed starship
}

main() {
	configfile nu
}
