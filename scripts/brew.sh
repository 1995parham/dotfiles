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
	echo '
 _
| |__  _ __ _____      __
| |_ \| |__/ _ \ \ /\ / /
| |_) | | |  __/\ V  V /
|_.__/|_|  \___| \_/\_/

  '
}

main() {
	if [[ "$OSTYPE" == "linux"* ]]; then
		msg "install the Homebrew dependencies:"
		if [[ "$(command -v apt)" ]]; then
			sudo apt-get install build-essential file curl git
		fi
	fi

	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

	if [[ "$OSTYPE" == "linux"* ]]; then
		msg "add homebrew to your profile"

		test -d $HOME/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"

		test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

		brew_eval="eval \$($(brew --prefix)/bin/brew shellenv)"

		if [ -r $HOME/.bash_profile ]; then
			grep -i "$brew_eval" $HOME/.bash_profile || echo "$brew_eval" >>$HOME/.bash_profile
		fi
		grep -i "$brew_eval" $HOME/.profile || echo "$brew_eval" >>$HOME/.profile
	fi
}
