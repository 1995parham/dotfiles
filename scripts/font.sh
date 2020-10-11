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
        echo "usage: font"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if [[ "$(command -v apt)" ]]; then
                sudo apt-get install fonts-roboto
        elif [[ "$(command -v pacman)" ]]; then
                sudo pacman -Syu --needed --noconfirm noto-fonts-emoji ttf-roboto
                yay -Syu --needed --noconfirm ttf-meslo
                yay -Syu --needed --noconfirm vazir-fonts
        fi
}
