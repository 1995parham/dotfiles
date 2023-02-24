#!/bin/bash

F_CYAN="\033[38;2;0;255;255m"
F_GREEN="\033[38;2;127;230;127m"
F_RED="\033[38;2;255;127;127m"
F_ORANGE="\033[38;2;255;165;0m"
F_YELLOW="\033[38;2;255;255;25m"
F_RESET="\033[39m"

function yes_or_no() {
	yes_to_all=${yes_to_all:-false}
	if $yes_to_all; then
		return 0
	fi

	local module=$1
	shift

	while true; do
		read -r -p "$(echo -e "\033[38;5;226m[$module] ${F_ORANGE}$*${F_RESET} [${F_GREEN}y${F_RESET}/${F_RED}n${F_RESET}]: ")" yn
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*)
			echo -e "${F_YELLOW}Aborted${F_RESET}"
			return 1
			;;
		esac
	done
}

function message() {
	local module=$1
	shift

	echo -e "${F_CYAN}[$module] ${F_ORANGE}$* $F_RESET"
}

function running() {
	local module=$1
	shift

	echo -e "${F_YELLOW}[$module] ${F_ORANGE}⇒ $* $F_RESET"
}

function action() {
	local module=$1
	shift

	echo -e "${F_RED}[$module] ${F_ORANGE}⇒ $* $F_RESET"
}

function ok() {
	local module=$1
	shift

	echo -e "${F_GREEN}[$module] ${F_ORANGE}⇒ $* $F_RESET"
}
