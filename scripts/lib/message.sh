#!/bin/bash

export F_CYAN="\033[38;2;0;255;255m"
export F_GREEN="\033[38;2;127;230;127m"
export F_RED="\033[38;2;255;127;127m"
export F_ORANGE="\033[38;2;255;165;0m"
export F_YELLOW="\033[38;2;255;255;25m"
export F_GRAY="\033[38;2;90;90;90m"
export F_BLUE="\033[38;2;0;191;255m"
export BOLD_ON="\033[1m"
export BOLD_OFF="\033[0m"
export F_RESET="\033[39m"

function yes_or_no() {
	yes_to_all=${yes_to_all:-0}
	if [ "$yes_to_all" == 1 ]; then
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
	local message=$2
	local servity=${3:-"info"}

	case $servity in
	info)
		servity=""
		;;
	error)
		servity="${F_RED}${BOLD_ON} ( error) ${F_RESET}${BOLD_OFF}"
		;;
	notice)
		servity="${F_ORANGE}${BOLD_ON} (  notice) ${F_RESET}${BOLD_OFF}"
		;;
	warn)
		servity="${F_YELLOW}${BOLD_ON} (  warn) ${F_RESET}${BOLD_OFF}"
		;;
	*)
		servity=""
		;;
	esac

	echo -e "$servity${F_CYAN}[$module] ${F_ORANGE}$message $F_RESET"
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
