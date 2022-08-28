#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# a global variable that points to dotfiles root directory.
# it used also in scripts/.
dotfiles_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR/lib
source "$dotfiles_root/scripts/lib/message.sh"
source "$dotfiles_root/scripts/lib/proxy.sh"
source "$dotfiles_root/scripts/lib/linker.sh"
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
	echo "  -f   force"
	echo "  -h   display help"
	echo "  -d   as dependency (internal usage)"
	echo "  -y   yes to all"
	echo ""
}

_main() {
	## global variables ##
	######################

	# global variable indicates force in specific script and runs script with root
	local force=false

	# global variable indicates show help for user in specific script
	# there is no need to use it in your script
	local show_help=false

	# ask no questions, use sane defaults
	local yes_to_all=false

	# as_dependency shows that this start.sh is going to install a dependency
	local as_dependency=false

	######################

	# parses options flags
	while getopts 'fdhy' argv; do
		case $argv in
		h)
			show_help=true
			;;
		f)
			force=true
			;;
		d)
			as_dependency=true
			;;
		y)
			yes_to_all=true
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
		message "pre" "it must run without the root permissions with a regular user."
		if [ $force = false ]; then
			exit 1
		fi
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
		if yes_or_no "[$script] do you want to install $additional as an additional package?"; then
			local options="-d"
			if [ $yes_to_all = true ]; then
				options="$options -y"
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

	if yes_or_no "[$script] do you want to install dependencies?"; then
		local options="-d"
		if [ $yes_to_all = true ]; then
			options="$options -y"
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
}

install() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		msg " darwin, using brew"

		if declare -f main_brew >/dev/null; then
			main_brew
		else
			msg "main_brew not found, there is nothing to do"
			exit
		fi

		return
	fi

	if [[ "$(command -v brew)" ]]; then
		msg "  linux with brew installed, using brew"

		if declare -f main_brew >/dev/null; then
			if yes_or_no "[$script] do you want to install with brew?"; then
				# brew installation on linux is optional
				main_brew
				return
			fi
		fi
	fi

	if [[ "$(command -v apt)" ]]; then
		msg " linux with apt installed, using apt"

		if declare -f main_apt >/dev/null; then
			main_apt
		else
			msg "main_apt not found, there is nothing to do"
			exit
		fi

		return
	fi

	if [[ "$(command -v pacman)" ]]; then
		msg " linux with pacman installed, using pacman/yay"

		if declare -f main_pacman >/dev/null; then
			main_pacman
		else
			msg "main_pacman not found, there is nothing to do"
			exit
		fi

		return
	fi
}

_main "$@"
