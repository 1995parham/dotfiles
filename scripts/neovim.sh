#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# shellcheck disable=2034
dependencies="node shell"

usage() {
	echo -n 'install edge version of neovim and general checkers/linters'
	# shellcheck disable=1004
	echo '
                       _
 _ __   ___  _____   _(_)_ __ ___
| |_ \ / _ \/ _ \ \ / / | |_ ` _ \
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|

  '
}

main_apt() {
	sudo apt install neovim python3-pynvim
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed neovim python-pynvim
}

main_brew() {
	brew install neovim
	python3 -mpip install pynvim
}
