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
	# shellcheck disable=2016,1004
	echo '
  ___ _ __ ___   __ _  ___ ___
 / _ \ |_ ` _ \ / _` |/ __/ __|
|  __/ | | | | | (_| | (__\__ \
 \___|_| |_| |_|\__,_|\___|___/

  '
}

main_brew() {
	# https://github.com/doomemacs/doomemacs/blob/develop/docs/getting_started.org#with-homebrew
	brew install git ripgrep

	brew tap d12frosted/emacs-plus
	msg 'installation based on emacs-plus'
	msg 'installation takes time and cpu because it compiles emacs from source'
	brew install emacs-plus@29 --with-native-comp --with-elrumo2-icon

	if [ ! -e /Applications/Emacs.app ]; then
		ln -s "$(brew --prefix)/opt/emacs-plus@29/Emacs.app" /Applications
	fi

	msg 'installing doom on osx manually is better because there are many errors'
}

main_apt() {
	msg "install emacs/ripgre with apt"

	sudo apt-get install fd-find
	sudo add-apt-repository -y -n ppa:ubuntu-elisp/ppa
	sudo apt-get update
	sudo apt-get install emacs-snapshot
}

main_pacman() {
	msg "install emacs/ripgre with pacman"
	yay -Syu --noconfirm --needed aur/emacs-gcc-wayland-devel-bin
	# sudo pacman -Syu --noconfirm --needed emacs ripgrep aspell aspell-en
}

main() {
	configfile doom "" emacs

	mkdir -p "$HOME/.config"
	if [ -d "$HOME/.config/emacs" ]; then
		read -r -p "[emacs] do you want to install doom emacs?[Y/n] " -n 1 install

		if [[ $install == "Y" ]]; then
			rm -Rf "$HOME/.config/emacs"
		fi
	fi

	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs || true

	proxy_start
	export no_proxy="github.com"
	"$HOME/.config/emacs/bin/doom" install
	"$HOME/.config/emacs/bin/doom" sync
	"$HOME/.config/emacs/bin/doom" upgrade
	proxy_stop

	if [[ "$USER" == "parham" ]]; then
		msg "hello master parham"
		[ ! -d "$HOME/org" ] && git clone git@github.com:parham-alvani/notes "$HOME/org"
		[ ! -d "$HOME/tasks" ] && git clone git@github.com:parham-alvani/tasks "$HOME/tasks"
	fi
}
