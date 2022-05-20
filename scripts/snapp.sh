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
	echo "install snapp corporation mail/calender/contacts"

	# shellcheck disable=1004,2016
	echo '
                           _
 ___  __ _ _ __ ___  _ __ | | ___
/ __|/ _` | |_ ` _ \| |_ \| |/ _ \
\__ \ (_| | | | | | | |_) | |  __/
|___/\__,_|_| |_| |_| .__/|_|\___|
                    |_|
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed mutt vdirsyncer khal
	yay davmail

	configfile davmail "" snapp
	configfile vdirsyncer "" snapp
	configfile mutt "" snapp

	systemctl --user enable davmail@snapp
	systemctl --user start davmail@snapp
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	return 0
}
