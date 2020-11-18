#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : firefox.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: firefox"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        sudo pacman -Syu --noconfirm --needed firefox

        configfile tridactyl "" firefox
}
