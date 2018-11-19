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
        echo "usage: $program_name [-r] [-h] [-p ip]"
        echo "  -r   reset dns to dhcp"
        echo "  -h   display help"
        echo "  -p   shecan ip"
}

to_dhcp=false
shecan="178.22.122.100"
# parses options flags
while getopts 'rhp:' argv; do
        case $argv in
                h)
                        usage
                        exit
                        ;;
                r)
                        to_dhcp=true
                        ;;
                p)
                        shecan=$OPTARG
                        ;;
        esac
done

http_code=$(curl -s -o /dev/null -w "%{http_code}" https://check.shecan.ir)
if [ $http_code -eq 200 ]; then
        echo "You are using shecan"
else
        echo "You are not using shecan"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ $to_dhcp = true ]; then
                echo "Resets DNS to DHCP defaults"
                networksetup -setdnsservers Wi-Fi empty
        else
                echo "Sets DNS to Awesome shecan $shecan"
                networksetup -setdnsservers Wi-Fi $shecan
        fi
else
        echo "This script just works with OSx"
fi
