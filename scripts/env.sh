#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : env.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
usage() {
	echo -n "installs required packages"
}

packages=(zsh tmux htop aria2 curl bat neovim vim jq yamllint)

brew_packages=(coreutils k6 inetutils inxi shfmt)
apt_packages=(python3-pynvim bmon atop)
pacman_packages=(python-pynvim inxi mtr shfmt atop)

main_apt() {
	sudo apt-get update -q

	msg "install ${apt_packages[*]} + ${packages[*]} with apt"
	sudo apt-get install ${apt_packages[@]} ${packages[@]}
}

main_pacman() {
	msg "install ${pacman_packages[*]} + ${packages[*]} with pacman"
	sudo pacman -Syu --noconfirm --needed ${pacman_packages[@]} ${packages[@]}
}

main_brew() {
	msg "install ${brew_packages[*]} + ${packages[*]} with brew"
	brew install ${brew_packages[*]} ${packages[@]}

	python3 -mpip install pynvim
}
