#!/bin/bash

usage() {
	echo -n "install texlive with ease without any package manager"
	# shellcheck disable=1004
	echo '
 _            _ _
| |_ _____  _| (_)_   _____
| __/ _ \ \/ / | \ \ / / _ \
| ||  __/>  <| | |\ V /  __/
 \__\___/_/\_\_|_| \_/ \___|

	'
}

packages=(
	# elsevier/ieee journals
	elsarticle ieeetran

	# presentation with beamer
	beamer beamertheme-metropolis pgfopts

	# xepersian from vafa khaleghi
	xepersian bidi zref

	# references with bib
	biblatex biber

	# linters
	lacheck chktex

	# make with latexmk
	latexmk

	# code snippets in your documents
	minted fvextra catchfile xstring framed

	# more math
	amsmath

	# selectively in/exclude pieces of text
	comment

	# a new interface for environments in latex
	environ

	# document configuration with tags
	tagging

	# more flexible than makeindex and is able to sort extended Latin or non-Latin alphabets
	xindy

	# control sectional headers
	sectsty
)

latest-install-texlive() {
	local directory
	directory=$(find /usr/local/texlive/ -maxdepth 1 -type d -regextype sed -regex '.*/[0-9]\{4\}' | sort -r | head -1)

	basename "$directory"
}

texlive-install() {
	if [ ! -d /usr/local/texlive ]; then
		texlive-install-
	else
		msg "remove already installed texlive if you want a reinstall"

		version=$(latest-install-texlive)

		msg "texlive: $version"

		if yes_or_no "texlive" "do you want to remove texlives?"; then
			sudo "/usr/local/texlive/$version/bin/x86_64-linux/tlmgr" path remove || true
			sudo rm -Rf /usr/local/texlive

			texlive-install-
		fi
	fi
}

texlive-install-() {
	msg "download the installer from tug.org"
	if [ ! -d texlive-installer ]; then
		mkdir texlive-installer
		curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -x -v -z -f - -C texlive-installer
	else
		msg "there is a failed installation of texlive, you need to remove the installer first"
	fi

	msg "install with the installer -- default scheme is small"
	cd texlive-installer/install-tl* || return
	sudo ./install-tl -scheme small
}

texlive-init() {
	msg "welcome to texlive initiation, your texlive installation was successful"

	local version
	version=$(latest-install-texlive)

	msg "symlinks texlive binaries into default locations"
	sudo "/usr/local/texlive/$version/bin/x86_64-linux/tlmgr" path add

	msg "tlmgr repositories are ready"
	sudo tlmgr option repository https://ctan.asis.sh/systems/texlive/tlnet/

	msg "update tlmgr itself"
	sudo tlmgr update --self
}

main_pacman() {
	texlive-install
	texlive-init

	msg "install required packages for better latex/xetex experience in persian"
	require_pacman texlab python-pygments graphviz
	# right now I don't know why we don't have texlive-upstream on aur anymore
	# yay -Syu --noconfirm --needed texlive-upstream
	require_aur libxcrypt-compat

	for package in "${packages[@]}"; do
		sudo tlmgr install "$package"
	done

	msg "symlinks texlive newly installed binaries into default locations"
	sudo tlmgr path add
}

main_brew() {
	msg "install basictex with brew"
	brew cask install basictex

	eval "$(/usr/libexec/path_helper)"

	msg "tlmgr repositories are ready"
	tlmgr option repository https://ctan.asis.sh/systems/texlive/tlnet/

	msg "install required packages for better latex/xetex experience in persian"
	for package in "${packages[@]}"; do
		tlmgr install "$package"
	done
}

main_apt() {
	texlive-install
	texlive-init

	msg "install required packages for better latex/xetex experience in persian"
	for package in "${packages[@]}"; do
		sudo tlmgr install "$package"
	done
	msg "symlinks texlive newly installed binaries into default locations"
	sudo tlmgr path add
}
