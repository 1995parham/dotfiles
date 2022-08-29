#!/bin/bash

function yes_or_no {
	yes_to_all=${yes_to_all:-0}
	if $yes_to_all; then
		return 0
	fi

	local module=$1
	shift

	while true; do
		read -r -p "$(echo -e "\e[38;5;226m[$module] \e[38;5;202m$*\e[39m [\e[38;5;46my\e[39m/\e[38;5;196mn\e[39m]: ")" yn
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*)
			echo -e "\e[38;5;196mAborted \e[39m"
			return 1
			;;
		esac
	done
}

function message() {
	local module=$1
	shift

	echo -e "\e[38;5;45m[$module] \e[38;5;202m$*\e[39m"
}

function running() {
	local module=$1
	shift

	echo -e "\e[38;5;226m[$module] \e[38;5;202m⇒ $* \e[39m"
}

function action() {
	local module=$1
	shift

	echo -e "\e[38;5;197m[$module] \e[38;5;202m⇒ $* \e[39m"
}

function ok() {
	local module=$1
	shift

	echo -e "\e[38;5;46m[$module] \e[38;5;202m⇒ $* \e[39m"
}
