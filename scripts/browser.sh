#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : browser.sh
#
# [] Creation Date : 01-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: browser"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "vivaldi" "Darwin"

                brew install --cask vivaldi
        else
                message "vivaldi" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "vivaldi" "install vivaldi with pacman"
                        sudo pacman -Syu --noconfirm --needed vivaldi vimb
                fi

                sed -i 's#BROWSER=.*#BROWSER='$(which vivaldi-stable)'#g' ~/.profile
                configfile "vimb" "config"
                configfile "vimb" "bookmark"
        fi
}
