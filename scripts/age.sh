#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : age.sh
#
# [] Creation Date : 31-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "A simple, modern and secure encryption tool (and Go library) with small explicit keys, no config options, and UNIX-style composability"

	# shellcheck disable=1004,2016
	echo '
  __ _  __ _  ___
 / _` |/ _` |/ _ \
| (_| | (_| |  __/
 \__,_|\__, |\___|
       |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm age
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "refer to keys repository for the keys"
}
