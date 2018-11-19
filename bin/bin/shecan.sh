#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : shecan.sh
#
# [] Creation Date : 19-11-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
program_name=$0

usage() {
        echo "By default it sets DNS to Awesome shecan (OSx ONLY)"
        echo "usage: $program_name [-r] [-h]"
        echo "  -r   reset dns to dhcp"
        echo "  -h   display help"
}

to_dhcp=false
# parses options flags
while getopts 'rh' argv; do
        case $argv in
                h)
                        usage
                        exit
                        ;;
                r)
                        to_dhcp=true
                        ;;
        esac
done

if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ $to_dhcp = true ]; then
                echo "Resets DNS to DHCP defaults"
                networksetup -setdnsservers Wi-Fi
        else
                echo "Sets DNS to Awesome shecan"
                networksetup -setdnsservers Wi-Fi 178.22.122.100
        fi
else
        echo "This script just works with OSx"
fi
