#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : cmus.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: cmus"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "cmus" "Darwin"

                brew install cmus
        else
                message "cmus" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "cmus" "install cmus with pacman"
                        sudo pacman -Syu --noconfirm --needed cmus
                fi
        fi

        configfile cmus rc
}
