#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : gotz.sh
#
# [] Creation Date : 12-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "CLI timezone info"
	# shellcheck disable=2016
	echo '
             _
  __ _  ___ | |_ ____
 / _` |/ _ \| __|_  /
| (_| | (_) | |_ / /
 \__, |\___/ \__/___|
 |___/
  '
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	yay -Syu --noconfirm --needed gotz
}

main() {
	configfile gotz config.json
}
