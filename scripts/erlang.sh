#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : erlang.sh
#
# [] Creation Date : 21-08-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "install erlang and remembers the good old days with dr.bakhshi"

	# shellcheck disable=1004,2016
	echo '
           _
  ___ _ __| | __ _ _ __   __ _
 / _ \ |__| |/ _| | |_ \ / _` |
|  __/ |  | | (_| | | | | (_| |
 \___|_|  |_|\__,_|_| |_|\__, |
                         |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm erlang
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "there is nothing that we can do"
	return 1
}
