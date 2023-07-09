#!/bin/bash
# https://about.gitlab.com/blog/2021/01/27/we-need-to-talk-no-proxy/

proxy_start() {
	if ! ss -tunl | grep :1080 &>/dev/null; then
		return 0
	fi

	echo -e "\033[38;5;46m[proxy] \033[38;5;202msetup proxy based on local http proxy which is setup by v2ray\033[39m"
	echo -e "\033[38;5;46m[proxy] \033[38;5;202mpress enter to continue or anything else to disable it\033[39m"
	read -r accept

	if [[ "$accept" != "" ]]; then
		return 0
	fi

	echo
	curl --max-time 10 ipconfig.io/country || return 1

	export ftp_proxy="http://127.0.0.1:1080"
	export http_proxy="http://127.0.0.1:1080"
	export https_proxy="http://127.0.0.1:1080"
	alias sudo='sudo -E'

	echo
	curl --max-time 10 ipconfig.io/country || proxy_stop
	echo
}

proxy_stop() {
	unset {http,https,ftp}_proxy || true
	unalias sudo 2>/dev/null || true

	echo -e "\033[38;5;46m[proxy] \033[38;5;202mall proxy script configurations are removed\033[39m"
}

socks_start() {
	echo -e "\033[38;5;46m[socks] \033[38;5;202msetup proxy based on local socks proxy which is setup by v2ray\033[39m"
	echo -e "\033[38;5;46m[socks] \033[38;5;202mpress enter to continue or anything else to disable it\033[39m"
	read -r accept

	if [[ "$accept" != "" ]]; then
		return 0
	fi

	echo
	curl --max-time 10 ifconfig.io/country_code || return 1

	export ftp_proxy="http://127.0.0.1:1080"
	export http_proxy="socks5://127.0.0.1:1086"
	export https_proxy="socks5://127.0.0.1:1086"
	alias sudo='sudo -E'

	echo
	curl --max-time 10 ifconfig.io/country_code || socks_stop
	echo
}

socks_stop() {
	unset {http,https,ftp}_proxy || true
	unalias sudo 2>/dev/null || true

	echo -e "\033[38;5;46m[socks] \033[38;5;202mall proxy script configurations are removed\033[39m"
}
