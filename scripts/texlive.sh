#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : texlive.sh
#
# [] Creation Date : 14-05-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: texlive"
}

texlive-package() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		sudo tlmgr install $@
	else
		tlmgr install $@
	fi
}

texlive-packages() {
	# elsevier journals
	texlive-package elsarticle

	# xepersian
	texlive-package xepersian bidi zref

	# presentation
	texlive-package beamer beamertheme-metropolis pgfopts

	# references
	texlive-package biblatex biber

	# linters
	texlive-package lacheck chktex

	# make
	texlive-package latexmk

	# code
	texlive-package minted fvextra catchfile xstring framed
}

texlive-install() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "texlive" "Linux"

		message "texlive" "Download the installer from tug.org"
		if [ ! -d texlive-installer ]; then
			mkdir texlive-installer
			curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -x -v -z -f - -C texlive-installer
		else
			message "texlive" "There is a failed installation of texlive"
		fi

		message "texlive" "Install with the installer -- default scheme is small"
		cd texlive-installer/install-tl*
		sudo ./install-tl -scheme small
	else
		message "texlive" "Darwin"

		message "texlive" "Install basictex with brew"
		brew cask install basictex

		eval "$(/usr/libexec/path_helper)"
	fi
}

main() {
	if [ ! -d /usr/local/texlive ]; then
		texlive-install
		message "texlive" "After installation you need to setup you path before you can use tlmgr so you need to run this script again"
		exit
	else
		message "texlive" "Remove already installed texlive if you want a reinstall"
	fi

	message "texlive" "Install required packages for better latex experience"
	if [[ $OSTYPE == "linux-gnu" ]]; then
		if [[ "$(command -v apt)" ]]; then
			message "texlive" "with apt"
		elif [[ "$(command -v pacman)" ]]; then
			message "texlive" "with pacman"
			sudo pacman -Syu --noconfirm --needed texlab python-pygments
		fi
		sudo tlmgr option repository ctan
	else
		message "texlive" "Darwin"
		tlmgr option repository ctan
	fi

	texlive-packages
}
