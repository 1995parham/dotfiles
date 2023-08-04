#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# a global variable that points to dotfiles root directory.
# it used also in scripts/.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
main_root="$root"
# shellcheck source=message.sh
source "$root/scripts/lib/message.sh"
# shellcheck source=proxy.sh
source "$root/scripts/lib/proxy.sh"
# shellcheck source=linker.sh
source "$root/scripts/lib/linker.sh"
# shellcheck source=require.sh
source "$root/scripts/lib/require.sh"

# start.sh
program_name=$0

trap '_end' INT

_end() {
	echo "see you in a better tomorrow [you signal start.sh execuation]"
	exit
}

_usage() {
	echo ""
	echo "usage: $program_name [-y] [-h] script [script options]"
	echo "  -h   display help"
	echo "  -d   as dependency (internal usage)"
	echo "  -y   yes to all"
	echo ""
	echo " $program_name new for creating a new script"
	echo " $program_name list for see available scripts"
	echo ""
}

_main() {
	## global variables ##
	######################

	# global variable indicates show help for user in specific script
	# there is no need to use it in your script
	local show_help=false

	# ask no questions, use sane defaults
	local yes_to_all=0

	# as_dependency shows that this start.sh is going to install a dependency
	local as_dependency=false

	######################

	# parses options flags
	while getopts 'dhy' argv; do
		case $argv in
		h)
			show_help=true
			;;
		d)
			as_dependency=true
			;;
		y)
			yes_to_all=1
			;;
		*)
			_usage
			;;
		esac
	done

	for ((i = 2; i <= OPTIND; i++)); do
		shift
	done

	if [ $as_dependency = false ]; then
		# shellcheck source=header.sh
		source "$root/scripts/lib/header.sh"
	fi

	# handles root user
	if [[ $EUID -eq 0 ]]; then
		message "pre" "it must run without the root permissions with a regular user." "error"
		return 1
	fi

	# handles given script run and result
	local script
	local start
	local took

	# https://stackoverflow.com/questions/7832080/test-if-a-variable-is-set-in-bash-when-using-set-o-nounset
	if [ "${1:+defined}" = "defined" ]; then
		script=$1
		shift
	else
		_usage
		script="list"
	fi

	case $script in
	"list")
		script="lib/list"
		;;
	"new")
		script="lib/new"
		;;
	"update")
		git subtree pull --prefix scripts/lib https://github.com/1995parham/dotfiles.lib.git main --squash
		return 0
		;;
	esac

	# shellcheck disable=1090
	if ! [ -f "$root/scripts/$script.sh" ] || ! source "$root/scripts/$script.sh" 2>/dev/null; then
		message "pre ""404 script not found" "notice"

		local host
		host="$HOSTNAME"
		host="${host%.*}"
		if ! [ -f "$root/$host/scripts/$script.sh" ] || ! source "$root/$host/scripts/$script.sh" 2>/dev/null; then
			message "pre ""404 script not found for $host" "notice"
			_usage
			return 1
		fi

		message "pre" "run scirpt for specific host: $host" "notice"
		root="$root/$host"
	fi

	_run "$@"

	local host
	host="$HOSTNAME"
	host="${host%.*}"
	# shellcheck disable=1090
	if ! [ -f "$root/$host/scripts/$script.sh" ] || ! source "$root/$host/scripts/$script.sh" 2>/dev/null; then
		return 0
	fi

	message "pre" "run scirpt for specific host: $host" "notice"
	root="$root/$host"

	_run "$@"
}

_run() {
	start=$(date +%s)
	if [ $show_help = true ]; then
		# prints the start.sh and the script helps
		_usage
		echo
		usage
	else
		# run the script
		msg() { message "$script" "$@"; }
		msg "$(usage)"

		# handle dependencies by executing the start.sh
		# for each of them separately
		if [[ "$(declare -p dependencies 2>/dev/null)" =~ "declare -a" ]]; then
			_dependencies "${dependencies[@]}"
		fi

		run "$@"

		# handle additional packages by executing the start.sh
		# for each of them separately
		if [[ "$(declare -p additionals 2>/dev/null)" =~ "declare -a" ]]; then
			_additionals "${additionals[@]}"
		fi
	fi

	echo
	took=$(($(date +%s) - start))
	printf "done. it took %d seconds.\n" $took
}

_additionals() {
	declare -a additionals
	additionals=("$@")

	if [ "${#additionals[@]}" -eq 0 ]; then
		return
	fi

	output=$(echo -n "additionals: |")
	output="$output"$(printf "%s|" "${additionals[@]}")
	msg "$output"

	for additional in "${additionals[@]}"; do
		read -ra additional <<<"$additional"

		if yes_or_no "$script" "do you want to install ${additional[0]} as an additional package?"; then
			local options="-d"
			if [ $yes_to_all = 1 ]; then
				options="${options}y"
			fi

			"$main_root/start.sh" "$options" "${additional[@]}"
		fi
	done
}

_dependencies() {
	declare -a dependencies
	dependencies=("$@")

	if [ "${#dependencies[@]}" -eq 0 ]; then
		return
	fi

	output=$(echo -n "dependencies: |")
	output="$output"$(printf "%s|" "${dependencies[@]}")
	msg "$output"

	if yes_or_no "$script" "do you want to install dependencies?"; then
		local options="-d"
		if [ $yes_to_all = 1 ]; then
			options="${options}y"
		fi

		for dependency in "${dependencies[@]}"; do
			read -ra dependency <<<"$dependency"
			"$main_root/start.sh" "$options" "${dependency[@]}"
		done
	fi
}

run() {
	install

	if declare -f main >/dev/null; then
		main "$@"
	fi

	if declare -f "main_$USER" >/dev/null; then
		msg " hello master $USER"
		"main_$USER" "$@"
	fi
}

install() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		msg " darwin, using brew"

		if declare -f main_brew >/dev/null; then
			main_brew
		else
			msg "main_brew not found, there is nothing to do" "error"
			exit
		fi

		return
	fi

	if [[ "$(command -v apt)" ]]; then
		msg " linux with apt installed, using apt"

		if declare -f main_apt >/dev/null; then
			main_apt
		else
			msg "main_apt not found, there is nothing to do" "error"
			exit
		fi

		return
	fi

	if [[ "$(command -v pacman)" ]]; then
		msg " linux with pacman installed, using pacman/yay"

		if declare -f main_pacman >/dev/null; then
			main_pacman
		else
			msg "main_pacman not found, there is nothing to do" "error"
			exit
		fi

		return
	fi
}

_main "$@"
