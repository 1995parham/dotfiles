#!/bin/bash

usage() {
	echo "install snapp corporation mail/calender/contacts"

	# shellcheck disable=1004,2016
	echo '
                             _
 ___ _ __   __ _ _ __  _ __ | |
/ __| |_ \ / _` | |_ \| |_ \| |
\__ \ | | | (_| | |_) | |_) |_|
|___/_| |_|\__,_| .__/| .__/(_)
                |_|   |_|
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

	msg "it is better to use thunderbird based on this awesome article from Elahe Dastan"
	msg "https://confluence.snapp.ir/display/SEC/set+up+desktop+email+client"
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	return 0
}
