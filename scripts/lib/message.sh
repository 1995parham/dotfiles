#!/bin/bash

function yes_or_no {
	yes_to_all=${yes_to_all:-0}
	if $yes_to_all; then
		return 0
	fi

	while true; do
		read -r -p "$* [y/n]: " yn
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*)
			echo "Aborted"
			return 1
			;;
		esac
	done
}

function message() {
	local module=$1
	shift

	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 45)[$module] $(tput setaf 202)$*$(tput sgr 0)"
	else
		echo -e "\e[38;5;45m[$module] \e[38;5;202m$*\e[39m"
	fi
}

function running() {
	local module=$1
	shift

	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 226)[$module] $(tput setaf 202)⇒ $*$(tput sgr 0)"
	else
		echo -e "\e[38;5;226m[$module] \e[38;5;202m⇒ $* \e[39m"
	fi
}

function action() {
	local module=$1
	shift

	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 197)[$module] $(tput setaf 202)⇒ $*$(tput sgr 0)"
	else
		echo -e "\e[38;5;197m[$module] \e[38;5;202m⇒ $* \e[39m"
	fi
}

function ok() {
	local module=$1
	shift

	if [[ "$(command -v tput)" ]]; then
		echo "$(tput setaf 46)[$module] $(tput setaf 202)⇒ $*$(tput sgr 0)"
	else
		echo -e "\e[38;5;46m[$module] \e[38;5;202m⇒ $* \e[39m"
	fi
}
