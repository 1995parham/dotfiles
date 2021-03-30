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
	echo -e "\e[38;5;46m[proxy] \e[38;5;202msetup proxy based on local http proxy that is setup by v2ray\e[39m"
	echo -n -e "\e[38;5;46m[proxy] \e[38;5;202mpress enter to continue?\e[39m"
	read accept

	if [[ "$accept" != "" ]]; then
		return 0
	fi

	echo
	curl --max-time 5 ipinfo.io/ip

	if [ $? -ne 0 ]; then
		return 1
	fi

	export ftp_proxy="http://127.0.0.1:1080"
	export http_proxy="http://127.0.0.1:1080"
	export https_proxy="http://127.0.0.1:1080"
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
	unalias sudo 2>/dev/null

	echo -e "\e[38;5;46m[proxy] \e[38;5;202mall proxy script configuration are removed\e[39m"
}
