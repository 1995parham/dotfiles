#!/bin/bash

usage() {
	echo "emacs with doom and bidirectional support"
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
	require_pacman ripgrep aspell aspell-en fd

	installed=$(pacman -Qqs "emacs" || echo "there is no installed emacs")

	PS3="select emacs installation kind ($installed):"

	kinds=(
		"emacs-nativecomp: The extensible, customizable, self-documenting real-time display editor with native compilation enabled"
		"emacs-nox: The extensible, customizable, self-documenting real-time display editor without X11 support"
		"emacs-pgtk-native-comp-git: GNU Emacs. Development master branch"
		"emacs-gcc-wayland-devel-bin: GNU Emacs. Development native-comp branch and pgtk branch combined, served as a binary."
	)

	select kind in "${kinds[@]}"; do
		kind=${kind%%:*}
		msg "installing $kind..."
		break
	done

	case $kind in
	emacs-nativecomp)
		require_pacman emacs-nativecomp
		;;
	emacs-nox)
		require_pacman emacs-nox
		;;
	emacs-gcc-wayland-devel-bin)
		require_aur emacs-gcc-wayland-devel-bin
		;;
	emacs-pgtk-native-comp-git)
		require_pacman webkit2gtk
		require_aur emacs-pgtk-native-comp-git
		;;
	esac
}

main() {
	configfile doom "" emacs

	mkdir -p "$HOME/.config"

	if [ -d "$HOME/.config/emacs" ]; then
		if yes_or_no "emacs" "do you want to install doom emacs?"; then
			msg 'removing doom'
			rm -Rf "$HOME/.config/emacs"
		fi
	fi

	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs 2>/dev/null || true

	msg "if you want to force straight to use your git config, set DOOMGITCONFIG to the path of your git config file!"
	export DOOMGITCONFIG=~/.config/git/config

	msg 'install, sync and upgrade doom with proxy'
	proxy_start
	export no_proxy="github.com"
	"$HOME/.config/emacs/bin/doom" install
	"$HOME/.config/emacs/bin/doom" sync
	"$HOME/.config/emacs/bin/doom" upgrade
	proxy_stop
}

main_parham() {
	msg "hello parham, clone your private repositories"

	if [ ! -d "$HOME/org" ]; then
		git clone git@github.com:parham-alvani/notes "$HOME/org"
	fi

	if [ ! -d "$HOME/tasks" ]; then
		git clone git@github.com:parham-alvani/tasks "$HOME/tasks"
	fi

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}
	(mkdir -p "$HOME/.config/emacs/.local/etc/workspaces/" || true) && cp "$dotfiles_root/emacs/sessions/main" "$HOME/.config/emacs/.local/etc/workspaces/"
	(mkdir -p "$HOME/.config/emacs/.local/cache/" || true) && cp "$dotfiles_root/emacs/sessions/projectile.projects" "$HOME/.config/emacs/.local/cache/"
}
