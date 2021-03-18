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
	echo "usage: alacritty"
}

main() {
	# Reset optind between calls to getopts
	OPTIND=1

	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "alacritty" "Darwin"

		brew install --cask alacritty
	else
		message "alacritty" "Linux"
		if [[ "$(command -v apt)" ]]; then
			echo "There is nothing that we can do"
		elif [[ "$(command -v pacman)" ]]; then
			message "alacritty" "install alacritty with pacman"
			sudo pacman -Syu --noconfirm --needed alacritty
		fi
	fi

	configfile alacritty
}
