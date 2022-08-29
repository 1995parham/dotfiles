#!/bin/bash

proxy_start() {
	echo -e "\033[38;5;46m[proxy] \033[38;5;202msetup proxy based on local http proxy which is setup by v2ray\033[39m"
	echo -e "\033[38;5;46m[proxy] \033[38;5;202mpress enter to continue or anything else to disable it\033[39m"
	read -r accept

	if [[ "$accept" != "" ]]; then
		return 0
	fi

	echo
	curl --max-time 10 ifconfig.io/country_code || return 1

	export ftp_proxy="http://127.0.0.1:1080"
	export http_proxy="http://127.0.0.1:1080"
	export https_proxy="http://127.0.0.1:1080"
	alias sudo='sudo -E'

	echo
	curl --max-time 10 ifconfig.io/country_code || proxy_stop
	echo
}

proxy_stop() {
	unset {http,https,ftp}_proxy || true
	unalias sudo 2>/dev/null || true

	echo -e "\033[38;5;46m[proxy] \033[38;5;202mall proxy script configurations are removed\033[39m"
}
