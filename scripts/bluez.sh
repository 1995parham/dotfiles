#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : bluez.sh
#
# [] Creation Date : 07-07-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "bluez is not a t-shirt"

	# shellcheck disable=1004,2016
	echo '
 _     _
| |__ | |_   _  ___ ____
| |_ \| | | | |/ _ \_  /
| |_) | | |_| |  __// /
|_.__/|_|\__,_|\___/___|
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm bluez bluez-utils bluez-tools
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service
}
