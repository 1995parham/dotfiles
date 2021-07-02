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

#main_apt() {
#	msg "install the Homebrew dependencies"
#	sudo apt-get install build-essential file curl git
#}

main() {
	yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [[ "$OSTYPE" == "linux"* ]]; then
		msg "add homebrew to your profile"

		test -d "$HOME/.linuxbrew" && eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"

		test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

		brew_eval="eval \$($(brew --prefix)/bin/brew shellenv)"

		if [ -r "$HOME/.bash_profile" ]; then
			grep -i "$brew_eval" "$HOME/.bash_profile" || echo "$brew_eval" >>"$HOME/.bash_profile"
		fi
		grep -i "$brew_eval" "$HOME/.profile" || echo "$brew_eval" >>"$HOME/.profile"
	fi
}
