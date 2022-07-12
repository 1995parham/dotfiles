#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : yt-dlp.sh
#
# [] Creation Date : 12-07-2022
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "A youtube-dl fork with additional features and fixes"
	# shellcheck disable=2016
	echo '
       _            _ _
 _   _| |_       __| | |_ __
| | | | __|____ / _| | | |_ \
| |_| | ||_____| (_| | | |_) |
 \__, |\__|     \__,_|_| .__/
 |___/                 |_|
	'
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed yt-dlp
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	configfile yt-dlp
}
