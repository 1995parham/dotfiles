#!/bin/bash

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
