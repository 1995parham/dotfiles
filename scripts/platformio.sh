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
        python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py)"
}

platformio-udev() {
        message "platformio" "Installing udev rules"
        curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
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
