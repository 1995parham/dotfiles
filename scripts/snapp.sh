#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : snapp.sh
#
# [] Creation Date : 17-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: snapp"
        echo "install snapp corporation mail/calender/contacts"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

	sudo pacman -Syu --noconfirm --needed mutt vdirsyncer khal element-desktop
        yay -Syu --noconfirm --needed davmail

        systemctl --user enable davmail@snapp
        systemctl --user start davmail@snapp

        configfile davmail "" snapp
        configfile khal "" snapp
        configfile vdirsyncer "" snapp
        configfile mutt "" snapp

        vdirsyncer discover
}
