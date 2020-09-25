#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : forticlient.sh
#
# [] Creation Date : 06-03-2019
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: forticlient"
}

forticlient-install() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "forticlient" "Linux"

		if [[ "$(command -v apt)" ]]; then
			message "fortclient" "Install forticlient from apt source"
			sudo apt install openfortivpn

			message "forticlient" "Install PPP"
			sudo apt install ppp

			message "forticlient" "you can install network-manager-fortisslvpn and network-manager-fortisslvpn-gnome to have it on network manager and nmcli"
		elif [[ "$(command -v pacman)" ]]; then
			message "forticlient" "Install network manager plugin for fortisslvpn"
			sudo pacman -Syu networkmanager-fortisslvpn
		fi
	else
		message "forticlient" "Darwin"

                message "forticlient" "Install forticlient from brew"
		brew install openfortivpn
	fi
}


main() {
        # Reset optind between calls to getopts
        OPTIND=1

        forticlient-install

        message "forticlient" "Create configuration file in current directory"

        message "forticlient" "Edit openfortivpn.conf file and update trusted-cert option with the string from the error. Make sure the option is not commented"
}
