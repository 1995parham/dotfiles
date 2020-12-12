#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : mail.sh
#
# [] Creation Date : 11-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: mail"
}

main() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "mail" "Darwin"

                brew install offlineimap
        else
                message "mail" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "mail" "install offlineimap with pacman"
                        sudo pacman -Syu --noconfirm --needed offlineimap
                        yay -Syu --noconfirm --needed mu
                fi
        fi

        configfile offlineimap "" mail

        mkdir -p ~/mail/aut
        mkdir -p ~/mail/main
        mkdir -p ~/mail/personal
        mkdir -p ~/mail/secret

         mu init --maildir ~/mail/secret --my-address 1995parham@hitler.rocks
         mu init --maildir ~/mail/aut --my-address parham.alvani@aut.ac.ir
}
