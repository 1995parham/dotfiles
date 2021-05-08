#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : cmus.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "cmus music player in terminal with 1995parham configuration"
	# shellcheck disable=1004
	echo '
  ___ _ __ ___  _   _ ___
 / __| |_ ` _ \| | | / __|
| (__| | | | | | |_| \__ \
 \___|_| |_| |_|\__,_|___/

  '
}

main_brew() {
	brew install cmus
}

main_apt() {
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed cmus
}

main() {
	configfile cmus rc
}
