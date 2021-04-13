#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : emacs.sh
#
# [] Creation Date : 06-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "emacs with bidirectional support"
}

main_brew() {
	msg "there is nothing that we can do"

	# https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#with-homebrew
	# brew install git ripgrep
	# brew install emacs
	return 1
}
main_apt() {
	msg "there is nothing that we can do"

	return 1
}

main_pacman() {
	msg "install emacs/ripgre with pacman"
	sudo pacman -Syu --noconfirm --needed emacs ripgrep
}

main() {
	configfile doom "" emacs

	mkdir -p "$HOME/.config"
	if [ -d "$HOME/.config/emacs" ]; then
		read -r -p "[emacs] do you want to install doom emacs?[Y/n] " -n 1 install

		if [[ $install == "Y" ]]; then
			rm -Rf "$HOME/.config/emacs"
		else
			return 0
		fi
	fi

	git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.config/emacs || true

	proxy_start
	"$HOME/.config/emacs/bin/doom" install
	proxy_stop
}
