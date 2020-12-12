#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : emacs.sh
#
# [] Creation Date : 06-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: emacs"
}

main() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "emacs" "Darwin"

                brew install ripgrep
                brew install --cask emacs
        else
                message "emacs" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "emacs" "install emacs/ripgre with pacman"
                        sudo pacman -Syu --noconfirm --needed emacs ripgrep
                fi
        fi

        configfile emacs "" ""
}
