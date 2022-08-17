#!/bin/bash

proxy_start() {
	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 46)[proxy] $(tput setaf 202)setup proxy based on local http proxy which is setup by v2ray$(tput sgr 0)"
		echo "$(tput setaf 46)[proxy] $(tput setaf 202)press enter to continue or anything else to disable it$(tput sgr 0)"
	else
		echo -e "\e[38;5;46m[proxy] \e[38;5;202msetup proxy based on local http proxy which is setup by v2ray\e[39m"
		echo -e "\e[38;5;46m[proxy] \e[38;5;202mpress enter to continue or anything else to disable it\e[39m"
	fi
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
	unset {http,https,ftp}_proxy
	unalias sudo 2>/dev/null

	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 46)[proxy] $(tput setaf 202)all proxy script configurations are removed$(tput sgr 0)"
	else
		echo -e "\e[38;5;46m[proxy] \e[38;5;202mall proxy script configurations are removed\e[39m"
	fi
}
