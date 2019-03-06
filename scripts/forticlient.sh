#!/bin/
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

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        message "fortclient" "Install forticlient for apt source"
        sudo apt install openfortivpn

        message "forticlient" "Install PPP"
        sudo apt install ppp

        message "forticlient" "Create configuration file in current directory"
        touch openfortivpn.conf
        chmod go= openfortivpn.conf

        message "forticlient" "Edit openfortivpn.conf file and update trusted-cert option with the string from the error. Make sure the option is not commented"
}
