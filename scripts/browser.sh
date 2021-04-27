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
	sudo pacman -Syu --noconfirm --needed firefox w3m firefox-developer-edition
	msg 'remove i3 BROWSER variable because it does nothing and also ruins everything'
	sed -i 's/export BROWSER=.*/# export BROWSER=/g' ~/.profile
	unset BROWSER

	bash xdg-settings set default-web-browser firefox.desktop
}

main_apt() {
	return 1
}
