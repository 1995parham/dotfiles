#!/bin/bash

# shellcheck disable=2034
dependencies="node shell"

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
	require_pacman python-pynvim luarocks
	require_aur neovim-git
}

main_brew() {
	brew install neovim
	python3 -mpip install pynvim
}

main() {
	if [ -d "$HOME/.config/nvim" ]; then
		cd "$HOME/.config/nvim" || return

		url=$(git remote get-url origin 2>/dev/null)
		if [[ "$url" =~ .*github.com[:/]1995parham/elievim ]]; then
			msg 'valid repository, so fetching it'
			git pull origin main
		else
			msg "invalid repository $url"

			read -r -p "[neovim] do you want to remove current neovim configuration?[Y/n] " -n 1 yes
			echo
			if [[ $yes == "Y" ]]; then
				msg 'removing current configuration to replace it with new configuration'
				rm -Rf ~/.config/nvim
				git clone git@github.com:1995parham/elievim ~/.config/nvim
			fi
		fi
	else
		git clone git@github.com:1995parham/elievim ~/.config/nvim
	fi
}
