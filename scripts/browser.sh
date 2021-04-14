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
	echo "browsers for daily use, we believe in firefox"
}

main_brew() {
	brew install --cask firefox
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed firefox w3m
	sed -i 's#BROWSER=.*#BROWSER='"$(which firefox)"'#g' ~/.profile
}

main_apt() {
	return 1
}
