#!/bin/bash

function yes_or_no {
	yes_to_all=${yes_to_all:-0}
	if $yes_to_all; then
		return 0
	fi

	local module=$1
	shift

	while true; do
		read -r -p "$(echo -e "\033[38;5;226m[$module] \033[38;5;202m$*\033[39m [\033[38;5;46my\033[39m/\033[38;5;196mn\033[39m]: ")" yn
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*)
			echo -e "\033[38;5;196mAborted \033[39m"
			return 1
			;;
		esac
	done
}

function message() {
	local module=$1
	shift

	echo -e "\033[38;5;45m[$module] \033[38;5;202m$*\033[39m"
}

function running() {
	local module=$1
	shift

	echo -e "\033[38;5;226m[$module] \033[38;5;202m⇒ $* \033[39m"
}

function action() {
	local module=$1
	shift

	echo -e "\033[38;5;197m[$module] \033[38;5;202m⇒ $* \033[39m"
}

function ok() {
	local module=$1
	shift

	echo -e "\033[38;5;46m[$module] \033[38;5;202m⇒ $* \033[39m"
}
