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
        echo "$(basename $0)"
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
        echo "Welcome to simple script for connecting to Ghermezi Openconnect"

        if ! hash openconnect 2>/dev/null; then
                echo "This script requires 'openconnect'"
                exit
        fi

        username="parham"
        url="oc.ghermezi.xyz:4443"

        connect $username $url
}

main $@
