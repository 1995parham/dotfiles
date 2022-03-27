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
	echo '
  ___ _ ____   __
 / _ \ |_ \ \ / /
|  __/ | | \ V /
 \___|_| |_|\_/

  '
}

# shellcheck disable=2034
dependencies="neovim"

packages=(zsh tmux htop aria2 curl bat vim jq yamllint fzf mosh figlet)

brew_packages=(coreutils k6 inetutils inxi fontconfig wget)
apt_packages=(bmon atop)
pacman_packages=(mtr github-cli inetutils websocat fuse2 dog yq man-pages usbutils exfat-utils openbsd-netcat speedtest-cli cpupower)
yay_packages=(jcal jwt-cli-bin actionlint-bin act-bin wakatime-cli-bin)

main_apt() {
	sudo apt-get update -q

	msg "install ${apt_packages[*]} + ${packages[*]} with apt"
	sudo apt-get install "${apt_packages[@]}" "${packages[@]}"
}

main_pacman() {
	msg "install ${pacman_packages[*]} + ${packages[*]} with pacman"
	sudo pacman -Syu --noconfirm --needed "${pacman_packages[@]}" "${packages[@]}"

	msg "install ${yay_packages[*]} with yay"
	yay -Syu --needed "${yay_packages[@]}"
}

main_brew() {
	msg "install ${brew_packages[*]} + ${packages[*]} with brew"
	brew install "${brew_packages[@]}" "${packages[@]}"
}
