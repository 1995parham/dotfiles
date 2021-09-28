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
	echo '
 _
| |__  _ __ _____      _____  ___ _ __
| |_ \| |__/ _ \ \ /\ / / __|/ _ \ |__|
| |_) | | | (_) \ V  V /\__ \  __/ |
|_.__/|_|  \___/ \_/\_/ |___/\___|_|

	'
}

main_brew() {
	brew install --cask firefox
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed firefox w3m firefox-developer-edition

	bash xdg-settings set default-web-browser firefox.desktop

	# msg 'nyxt - the internet on your terms'
	# yay -Syu --noconfirm --needed nyxt
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	# configfile nyxt
	msg "please install the native tridactyl from its normal mode"
}
