#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "useful packages for linux-surface"

	# shellcheck disable=1004
	echo '
                 __
 ___ _   _ _ __ / _| __ _  ___ ___
/ __| | | | |__| |_ / _` |/ __/ _ \
\__ \ |_| | |  |  _| (_| | (_|  __/
|___/\__,_|_|  |_|  \__,_|\___\___|

	'
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu --needed --noconfirm surface-control-bin libwacom-surface
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
