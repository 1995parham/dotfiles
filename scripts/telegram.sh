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
	echo -n -e "free and open source, cross-platform, cloud-based instant messaging software"

	# shellcheck disable=1004,2016
	echo '
 _       _
| |_ ___| | ___  __ _ _ __ __ _ _ __ ___
| __/ _ \ |/ _ \/ _` | |__/ _| | |_ | _ \
| ||  __/ |  __/ (_| | | | (_| | | | | | |
 \__\___|_|\___|\__, |_|  \__,_|_| |_| |_|
                |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm telegram-desktop
}

main_brew() {
	brew install --cask telegram-desktop
}

main() {
	msg "there is nothing that we can do"
	return 1
}
