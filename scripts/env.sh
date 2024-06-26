#!/usr/bin/env bash

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
export dependencies=("fetch" "zsh" "bash")

packages=(tmux htop aria2 curl bat vim jq yamllint fzf mosh figlet lolcat)

brew_packages=(
	coreutils
	k6
	inetutils
	inxi
	fontconfig
	wget
	tmuxp
	dua-cli
	git
	bash
	ripgrep
	fd
	glab
	jless
	gh
	just
	bat-extras
	wakatime-cli
	muzzle
	jcal
	teamookla/speedtest/speedtest
	chafa
	mtr
	yq
	watch
	mike-engel/jwt-cli/jwt-cli
	taplo
	actionlint
	xdg-ninja
	the-unarchiver
)

apt_packages=(bmon atop jcal)

pacman_packages=(
	perl-image-exiftool
	ripgrep
	mtr
	git-delta
	fd
	jless
	chafa
	dua-cli
	github-cli glab
	inetutils websocat fuse2
	go-yq man-pages usbutils exfat-utils
	openbsd-netcat
	cpupower
	reflector
	jwt-cli
	tokei
	glow
	tmuxp
	arch-wiki-lite arch-wiki-docs
	pastel
	man-db
	bandwhich
	lsof
	vhs
	just
	bat-extras
	tcpdump
	powertop
	taplo-cli
)
yay_packages=(
	jcal
	actionlint-bin
	cbonsai
	k6
	ookla-speedtest-bin
)

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
