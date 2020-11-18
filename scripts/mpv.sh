#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : mpv.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: mpv"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        sudo pacman -Syu --noconfirm --needed mpv
        configfile mpv
}
