#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : platformio.sh
#
# [] Creation Date : 13-12-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
	echo -n -e "platformio, professional collaborative platform for embedded development"

	# shellcheck disable=1004,2016
	echo '
       _       _    __                      _
 _ __ | | __ _| |_ / _| ___  _ __ _ __ ___ (_) ___
| |_ \| |/ _| | __| |_ / _ \| |__| |_ |_ \| |/ _ \
| |_) | | (_| | |_|  _| (_) | |  | | | | | | | (_) |
| |__/|_|\____|\__|_|  \___/|_|  |_| |_| |_|_|\___/
|_|
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu --needed --noconfirm platformio
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
