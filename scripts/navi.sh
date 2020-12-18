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
        echo "usage: navi"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "navi" "Darwin"

                brew install navi
        else
                message "navi" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "navi" "install navi with yay"
                        yay -Syu --noconfirm --needed navi-bin
                fi
        fi

        navi repo add 1995parham/cheats
}
