#!/bin/bash

usage() {
	echo -e "fast and lightweight dns proxy as ad-blocker for local network with many features"

	# shellcheck disable=1004,2016,2028
	echo '
 _     _            _
| |__ | | ___   ___| | ___   _
| |_ \| |/ _ \ / __| |/ / | | |
| |_) | | (_) | (__|   <| |_| |
|_.__/|_|\___/ \___|_|\_\\__, |
                         |___/

  '
}

main_pacman() {
	require_aur blocky
}

main() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg 'create configuration on /etc/blocky.yml by copying it'
	sudo cp "$dotfiles_root/blocky/blocky.yml" /etc/blocky.yml

	msg 'clone StevenBlack hosts from github to start blocky fast'
	sudo git clone "https://github.com/StevenBlack/hosts.git" /opt/hosts 2>/dev/null ||
		(cd "/opt/hosts" && sudo git pull)
}
