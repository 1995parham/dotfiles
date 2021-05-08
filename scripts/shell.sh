#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : shell.sh
#
# [] Creation Date : 14-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "write shell scripts with confidence"
	echo '
     _          _ _
 ___| |__   ___| | |
/ __| |_ \ / _ \ | |
\__ \ | | |  __/ | |
|___/_| |_|\___|_|_|

  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm shfmt shellcheck
}

main_brew() {
	brew install shfmt
}

main_apt() {
	sudo apt install shellcheck
}
