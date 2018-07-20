#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : platformio.sh
#
# [] Creation Date : 13-12-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
        echo "usage: platformio [-d]"
        echo "  -d   install udev rule"
}

platformio-install() {
        message "platformio" "Installing PlatformIO"
        sudo pip2 install -U platformio
}

platformio-udev() {
        message "platformio" "Installing udev rules"
        sudo curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/99-platformio-udev.rules > /etc/udev/rules.d/99-platformio-udev.rules
        sudo service udev restart
}

main() {
        install_udev=false

        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "d" argv; do
	        case $argv in
		        d)
                                install_udev=true
			        ;;
	        esac
        done
	
        platformio-install
        if [ $install_udev = true ]; then
                platformio-udev
        fi
}
