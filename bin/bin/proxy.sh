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

        if [ $? -ne 0 ]; then
                return 1
        fi

        export {http,https,ftp}_proxy="http://127.0.0.1:1080"
        alias sudo='sudo -E'

        echo
        curl --max-time 5 ipinfo.io/ip

        if [ $? -ne 0 ]; then
                proxy_stop
                return 1
        fi
}

proxy_stop() {
        unset {http,https,ftp}_proxy
        unalias sudo
        echo "[proxy] All proxy script configuration are removed"
}


if [ $# -ne 1 ]; then
        echo "proxy [start/stop]"
fi

if [ $1 = "start" ]; then
        proxy_start
fi

if [ $1 = "stop" ]; then
        proxy_stop
fi
