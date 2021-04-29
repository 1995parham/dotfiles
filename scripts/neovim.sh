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
dependencies="node"

usage() {
	echo -n 'install edge version of neovim'
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	msg "remove old neovim"
	sudo pacman -Rsu neovim || true

	msg "install edge neovim"
	yay -Syu --noconfirm --needed neovim-nightly-bin
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
