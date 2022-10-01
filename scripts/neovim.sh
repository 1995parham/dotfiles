#!/bin/bash

export dependencies=("node" "go" "rust")
export additionals=("shell" "java")

usage() {
	echo -n 'install edge version of neovim with nodejs, lua and pip'
	# shellcheck disable=1004
	echo '
                       _
 _ __   ___  _____   _(_)_ __ ___
| |_ \ / _ \/ _ \ \ / / | |_ ` _ \
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|

  '
}

main_apt() {
	sudo apt install neovim python3-pynvim
}

main_pacman() {
	# require_aur neovim-git
	require_pacman neovim libvterm
	require_pacman python-pynvim luarocks
}

main_brew() {
	require_brew luarocks
	require_brew_head neovim
	python3 -mpip install pynvim
}

main() {
	if [ -d "$HOME/.config/nvim" ]; then
		cd "$HOME/.config/nvim" || return

		url=$(git remote get-url origin 2>/dev/null)
		if [[ "$url" =~ .*github.com[:/]1995parham/elievim ]]; then
			msg 'valid repository, so fetching it'
			git pull origin main

			return 0
		else
			msg "invalid repository $url"

			if yes_or_no "neovim" "do you want to remove current neovim configuration?"; then
				msg 'removing current configuration to replace it with new configuration'
				rm -Rf ~/.config/nvim
			else
				return 1
			fi
		fi
	fi

	if [ -e "$HOME/.config/nvim" ] || [ -L "$HOME/.config/nvim" ]; then
		if yes_or_no "neovim" "do you want to remove current neovim configuration?"; then
			msg 'removing current configuration to replace it with new configuration'
			rm -Rf ~/.config/nvim
		else
			return 1
		fi
	fi
	git clone https://github.com/1995parham/elievim ~/.config/nvim
}
