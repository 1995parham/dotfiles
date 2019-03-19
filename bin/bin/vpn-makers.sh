#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : vpn-makers.sh
#
# [] Creation Date : 30-04-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
        echo "$(basename $0) [-h] [-o]"
        echo "-h use Parham's home user of VPN Makers [ir273269]"
        echo "-o use Parham's out-of-home user of VPN Makers (default) [ir536722]"
        echo "-u server url that can be found on 'https://vpnmakers.com/servers?p=cisco'"
}

connect() {
        username=$1
        url=$2

        echo "---"
        echo "create connection to $username@$url"
        echo "---"

        sudo openconnect $url -u $username
}

main() {
        echo "Welcome to simple script for connecting to VPN Makers"

        if ! hash openconnect 2>/dev/null; then
                echo "This script uses VPN Makers cisco protocl and requires 'openconnect'"
                exit
        fi

        username="ir536722"
        url="us4.cisadd2.com"
        while getopts 'hou:' argv; do
                case $argv in
                        o)
                                username="ir536722"
                                ;;
                        h)
                                username="ir273269"
                                ;;
                        u)
                                url=$OPTARG
                                ;;
                esac
        done

        connect $username $url
}

main $@
