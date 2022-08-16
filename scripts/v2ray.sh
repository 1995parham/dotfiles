#!/bin/bash

usage() {
	echo -n -e "v2ray for u.s. unfair sanctions"

	# shellcheck disable=1004,2016
	echo '
       ____
__   _|___ \ _ __ __ _ _   _
\ \ / / __) | |__/ _| | | | |
 \ V / / __/| | | (_| | |_| |
  \_/ |_____|_|  \__,_|\__, |
                       |___/
  '
}

main_apt() {
	curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh >install-release.sh
	chmod +x install-release.sh
	sudo ./install-release.sh
	rm install-release.sh

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	sudo cp "$dotfiles_root/ghermezi/config.json" /usr/local/etc/v2ray/config.json
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm v2ray

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	sudo cp "$dotfiles_root/ghermezi/config.json" /etc/v2ray/config.json
}

main_brew() {
	brew install v2ray
	brew services start v2ray

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	cp "$dotfiles_root/ghermezi/config.json" "$(brew --prefix)/etc/v2ray/config.json"
}
