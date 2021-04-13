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
	echo -n "alacritty terminal with jetbrains mono font and configuration"
}

main_brew() {
	brew install --cask alacritty
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed alacritty
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	configfile alacritty
}
