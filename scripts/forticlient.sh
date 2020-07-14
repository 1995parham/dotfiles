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

                message "fortclient" "Install forticlient from apt source"
                sudo apt install openfortivpn

                message "forticlient" "Install PPP"
                sudo apt install ppp
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
