#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -e

# global variable that points to dotfiles root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/message.sh
source "$current_dir/scripts/lib/message.sh"
# shellcheck source=scripts/lib/proxy.sh
source "$current_dir/scripts/lib/proxy.sh"
# shellcheck source=scripts/lib/linker.sh
source "$current_dir/scripts/lib/linker.sh"
# shellcheck source=scripts/lib/header.sh
source "$current_dir/scripts/lib/header.sh"

# start.sh
program_name=$0

trap '_end' INT

_end() {
	echo "see you later :) [you signal start.sh execuation]"
	exit
}

_usage() {
	echo "usage: $program_name [-p] [-h] [-f] script [script options]"
	echo "  -h   display help"
	echo "  -f   force"
}

_main() {
	## global variables ##

	# global variable indicates force in specific script and runs script with root
	local force=false

	# global variable indicates show help for user in specific script
	# there is no need to use it in your script
	local show_help=false

	# parses options flags
	while getopts 'hf' argv; do
		case $argv in
		h)
			show_help=true
			;;
		f)
			force=true
			;;
		*)
			_usage
			;;
		esac
	done

	for ((i = 2; i <= OPTIND; i++)); do
		shift
	done

	# handles root user
	if [[ $EUID -eq 0 ]]; then
		message "pre" "it must run without the root permissions with a regular user."
		if [ $force = false ]; then
			exit 1
		fi
		message "pre" "I hope you know what you are doing by using -f."
	fi

	# handles given script run and result
	local script
	local start
	local took

	if [ -z "$1" ]; then
		_usage
		exit
	fi
	script=$1
	shift

	start=$(date +'%s')

	# shellcheck disable=1090
	source "$current_dir/scripts/$script.sh" 2>/dev/null || {
		echo "404 script not found"
		exit
	}
	if [ $show_help = true ]; then
		# prints the start.sh and the script helps
		_usage
		echo
		usage
	else
		# run the script
		msg() { message "$script" "$@"; }
		msg "$(usage)"
		run "$@"
	fi

	echo
	took=$(($(date +'%s') - start))
	printf "done. it took %d seconds.\n" $took
}

run() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "pre" "darwin with brew (osx?)"

		if declare -f main_brew >/dev/null; then
			main_brew
		else
			message "pre" "main_brew not found"
		fi
	else
		if [[ "$(command -v brew)" ]]; then
			message "pre" "linux with brew (ubuntu?)"

			if declare -f main_brew >/dev/null; then
				read -r -p "[pre] do you want to install with brew?[Y/n] " -n 1 install
				echo

				if [[ $install == "Y" ]]; then
					# brew installation on linux is optional
					main_brew || true
				fi
			else
				message "pre" "main_brew not found"
			fi
		fi

		if [[ "$(command -v apt)" ]]; then
			message "pre" "linux with apt (ubuntu?)"

			if declare -f main_apt >/dev/null; then
				main_apt
			else
				message "pre" "main_apt not found"
			fi
		elif [[ "$(command -v pacman)" ]]; then
			message "pre" "linux with pacman (manjaro?)"

			if declare -f main_pacman >/dev/null; then
				main_pacman
			else
				message "pre" "main_pacman not found"
			fi
		fi
	fi

	# run the script
	if declare -f main >/dev/null; then
		main "$@"
	else
		message "pre" "main not found"
	fi
}

_main "$@"
