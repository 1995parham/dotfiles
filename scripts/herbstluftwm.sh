#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : herbstluftwm.sh
#
# [] Creation Date : 12-07-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "a manual tiling window manager for the X window system."

	# shellcheck disable=1004,2016
	echo '
 _               _         _   _        __ _
| |__   ___ _ __| |__  ___| |_| |_   _ / _| |___      ___ __ ___
| |_ \ / _ \ |__| |_ \/ __| __| | | | | |_| __\ \ /\ / / |_ ` _ \
| | | |  __/ |  | |_) \__ \ |_| | |_| |  _| |_ \ V  V /| | | | | |
|_| |_|\___|_|  |_.__/|___/\__|_|\__,_|_|  \__| \_/\_/ |_| |_| |_|

  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm herbstluftwm

	configfile herbstluftwm "" herbstluftwm
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "there is nothing that we can do"
	return 1
}
