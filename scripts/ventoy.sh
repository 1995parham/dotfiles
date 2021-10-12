#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : ventoy.sh
#
# [] Creation Date : 12-10-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "a new bootable USB solution"

	echo '
                 _
__   _____ _ __ | |_ ___  _   _
\ \ / / _ \ |_ \| __/ _ \| | | |
 \ V /  __/ | | | || (_) | |_| |
  \_/ \___|_| |_|\__\___/ \__, |
                          |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu --needed --noconfirm ventoy-bin
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	return 0
}
