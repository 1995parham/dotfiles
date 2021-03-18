#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : browser.sh
#
# [] Creation Date : 01-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: browser"
}

main() {
	# Reset optind between calls to getopts
	OPTIND=1

	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "browser" "Darwin"

		brew install --cask firefox
	else
		message "browser" "Linux"
		if [[ "$(command -v apt)" ]]; then
			echo "There is nothing that we can do"
		elif [[ "$(command -v pacman)" ]]; then
			message "browser" "install firefox / w3m with pacman"
			sudo pacman -Syu --noconfirm --needed firefox w3m
		fi

		sed -i 's#BROWSER=.*#BROWSER='$(which firefox)'#g' ~/.profile
	fi
}
