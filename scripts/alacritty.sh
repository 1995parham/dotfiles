#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : alacritty.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: alacritty"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        sudo pacman -Syu --noconfirm --needed alacritty
        configfile alacritty
}
