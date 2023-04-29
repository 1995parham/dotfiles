#!/bin/bash

usage() {
	echo -n "installs required packages for having a working system"
	echo '
  ___ _ ____   __
 / _ \ |_ \ \ / /
|  __/ | | \ V /
 \___|_| |_|\_/

  '
}

# neovim right now has very high cpu/memory usage and it is not suitable
# for every system.
# export dependencies=("neovim")
export dependencies=("fetch")

packages=(zsh tmux htop aria2 curl bat vim jq yamllint fzf mosh figlet)

brew_packages=(coreutils k6 inetutils inxi fontconfig wget tmuxp dua-cli git bash)
apt_packages=(bmon atop)
pacman_packages=(
	perl-image-exiftool
	rg
	mtr
	git-delta
	fd ripgrep
	jless
	chafa
	dua-cli
	github-cli glab
	inetutils websocat fuse2
	dog go-yq man-pages usbutils exfat-utils
	openbsd-netcat
	speedtest-cli
	cpupower
	reflector
	jwt-cli
	tokei
	glow
	wakatime
	tmuxp
	arch-wiki-lite arch-wiki-docs
	pastel
	man-db
	bandwhich
	lsof
	vhs
)
yay_packages=(jcal actionlint-bin cbonsai)

main_apt() {
	sudo apt update -yq

	msg "install ${apt_packages[*]} + ${packages[*]} with apt"
	require_apt "${apt_packages[@]}" "${packages[@]}"
}

main_pacman() {
	msg "install ${pacman_packages[*]} + ${packages[*]} with pacman"
	require_pacman "${pacman_packages[@]}" "${packages[@]}"

	msg "install ${yay_packages[*]} with yay"
	require_aur "${yay_packages[@]}"
}

main_brew() {
	msg "install ${brew_packages[*]} + ${packages[*]} with brew"
	require_brew "${brew_packages[@]}" "${packages[@]}"
}
