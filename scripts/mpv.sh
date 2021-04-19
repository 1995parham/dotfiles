#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : mpv.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: mpv"
}

main() {
	# Reset optind between calls to getopts
	OPTIND=1

	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "mpv" "Darwin"

		brew install --cask mpv
	else
		message "mpv" "Linux"
		if [[ "$(command -v apt)" ]]; then
			echo "There is nothing that we can do"
		elif [[ "$(command -v pacman)" ]]; then
			message "mpv" "install mpv with pacman"
			sudo pacman -Syu --noconfirm --needed mpv
		fi
	fi

	configfile mpv
}
