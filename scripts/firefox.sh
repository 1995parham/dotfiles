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

        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "firefox" "Darwin"

                brew install --cask firefox
        else
                message "firefox" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "firefox" "install firefox with pacman"
                        sudo pacman -Syu --noconfirm --needed firefox
                fi
        fi


        configfile tridactyl "" firefox
}
