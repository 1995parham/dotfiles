#!/bin/bash

usage() {
	echo "install snapp corporation mail/calender/contacts + chat"

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

export dependencies=(java)

main_pacman() {
	require_pacman mutt vdirsyncer thunderbird
	require_pacman element-web element-desktop
	require_aur davmail

	configfile davmail "" snapp
	configfile vdirsyncer "" snapp
	configfile mutt "" snapp

	systemctl --user enable davmail@snapp
	systemctl --user start davmail@snapp

	msg "it is better to use thunderbird based on this awesome article from Elahe Dastan"
	msg "https://confluence.snapp.ir/display/SEC/set+up+desktop+email+client"
}

main() {
	return 0
}
