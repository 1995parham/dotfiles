#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : mpd.sh
#
# [] Creation Date : 12-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "console carddav client"
	# shellcheck disable=2016
	echo '
 _    _           _
| | _| |__   __ _| |
| |/ / |_ \ / _| | |
|   <| | | | (_| | |
|_|\_\_| |_|\__,_|_|
  '
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed khal
}

main() {
	configfile khal khal.conf
	git clone git@github.com:parham-alvani/calendar.git "$HOME/Documents/Git/parham/parham-alvani/calendar" || true
}
