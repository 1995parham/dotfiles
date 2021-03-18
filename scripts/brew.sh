#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: brew [-p]"
	echo "-p: install .profile or .bash_profile for using brew"
}

main() {
	install_profile=false

	# Reset optind between calls to getopts
	OPTIND=1
	while getopts "p" argv; do
		case $argv in
		p)
			install_profile=true
			;;
		esac
	done

	if [[ "$OSTYPE" == "linux"* ]]; then
		message "brew" "install the Homebrew dependencies:"
		if [[ "$(command -v apt)" ]]; then
			sudo apt-get install build-essential file curl git
		fi
		if [[ "$(command -v pacman)" ]]; then
			sudo pacman -Suy base-devel
		fi

	fi

	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	if [[ "$OSTYPE" == "linux"* ]]; then
		if [ $install_profile = true ]; then
			message "brew" "add Homebrew to your PATH:"
			test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
			test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
			test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
			echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
		fi
	fi
}
