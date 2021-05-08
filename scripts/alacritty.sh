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
	# shellcheck disable=2016
	echo '
       _                 _ _   _
  __ _| | __ _  ___ _ __(_) |_| |_ _   _
 / _` | |/ _` |/ __| |__| | __| __| | | |
| (_| | | (_| | (__| |  | | |_| |_| |_| |
 \__,_|_|\__,_|\___|_|  |_|\__|\__|\__, |
                                   |___/
	'
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
