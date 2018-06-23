#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : scripts/lib/proxy.sh
#
# [] Creation Date : 24-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

proxy_start() {
        dig +short myip.opendns.com @resolver1.opendns.com

        # ssh -fTN -L 38080:127.0.0.1:38080 $parham_usvs
        echo "[proxy] Welcome to proxy script"
        read -p "Password: " -s password
        export {http,https,ftp}_proxy=sam:$password@ssl.gates.ga:50505

        if [ $EUID -eq 0 ]; then
                echo "Acquire::http::proxy \"http://sam:$password@ssl.gates.ga:50505/\";" > /etc/apt/apt.conf.d/95proxies
        fi

        echo
        curl ipinfo.io/ip
}

proxy_stop() {
        # ps aux | grep "ssh -fTN" | grep "38080:" | awk '{print $2}' | xargs kill

        if [ $EUID -eq 0 ]; then
	        rm /etc/apt/apt.conf.d/95proxies
        fi
        unset {http,https,ftp}_proxy
        echo "[proxy] All proxy script configuration are removed"
}
