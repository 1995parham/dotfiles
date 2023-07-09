#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# a global variable that points to dotfiles root directory.
# it used also in scripts/.
dotfiles_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/message.sh
source "$dotfiles_root/scripts/lib/message.sh"
# shellcheck source=scripts/lib/proxy.sh
source "$dotfiles_root/scripts/lib/proxy.sh"
# shellcheck source=scripts/lib/linker.sh
source "$dotfiles_root/scripts/lib/linker.sh"
# shellcheck source=scripts/lib/require.sh
source "$dotfiles_root/scripts/lib/require.sh"

# start.sh
program_name=$0

trap '_end' INT

_end() {
	echo "see you in a better tomorrow [you signal start.sh execuation]"
	exit
}

_usage() {
	echo ""
	echo "usage: $program_name [-y] [-h] [-f] script [script options]"
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
	while getopts 'fdhy' argv; do
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
		# shellcheck source=scripts/lib/header.sh
		source "$dotfiles_root/scripts/lib/header.sh"
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

	start=$(date +%s)

	# shellcheck disable=1090
	source "$dotfiles_root/scripts/$script.sh" 2>/dev/null || {
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

		# handle dependencies by executing the start.sh
		# for each of them separately
		dependencies=${dependencies:-""}
		_dependencies "${dependencies[@]}"

		run "$@"

		# handle additional packages by executing the start.sh
		# for each of them separately
		additionals=${additionals:-""}
		_additionals "${additionals[@]}"
	fi

	echo
	took=$(($(date +%s) - start))
	printf "done. it took %d seconds.\n" $took
}

_additionals() {
	additionals=$*

	if [ -z "$additionals" ]; then
		return
	fi

	msg "additionals: $additionals"

	for additional in $additionals; do
		if yes_or_no "$script" "do you want to install $additional as an additional package?"; then
			local options="-d"
			if [ $yes_to_all = 1 ]; then
				options="${options}y"
			fi

			"$dotfiles_root/start.sh" "$options" "$additional"
		fi
	done
}

_dependencies() {
	dependencies=$*

	if [ -z "$dependencies" ]; then
		return
	fi

	msg "dependencies: $dependencies"

	if yes_or_no "$script" "do you want to install dependencies?"; then
		local options="-d"
		if [ $yes_to_all = 1 ]; then
			options="${options}y"
		fi

		for dependency in $dependencies; do
			"$dotfiles_root/start.sh" "$options" "$dependency"
		done
	fi
}

run() {
	install

	if declare -f main >/dev/null; then
		main "$@"
	fi

	if declare -f main_parham >/dev/null; then
		if [[ "$USER" == "parham" ]]; then
			msg ' hello master'
			main_parham "$@"
		fi
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
