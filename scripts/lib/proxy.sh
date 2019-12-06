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

        export {http,https,ftp}_proxy="http://127.0.0.1:1087"

        echo
        curl -m 1 ipinfo.io/ip
}

proxy_stop() {
        unset {http,https,ftp}_proxy
        echo "[proxy] All proxy script configuration are removed"
}
