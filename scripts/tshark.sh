#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : tshark.sh
#
# [] Creation Date : 05-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
        echo "usage: tshark"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        message "tshark" "Install tshark from apt source"
        sudo apt-get install tshark

        message "tshark" "Non-root users can capture from interfaces"
        sudo dpkg-reconfigure wireshark-common
        sudo adduser $USER wireshark
}
