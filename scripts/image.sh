#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : image.sh
#
# [] Creation Date : 05-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "image manipulation tools including: imagemagick (convert), gimp"
	# shellcheck disable=2016,1004
	echo '
 _
(_)_ __ ___   __ _  __ _  ___
| | |_ ` _ \ / _` |/ _` |/ _ \
| | | | | | | (_| | (_| |  __/
|_|_| |_| |_|\__,_|\__, |\___|
                   |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm gimp imagemagick imv
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
