#!/bin/bash

usage() {
	echo -e "Fast and lightweight DNS proxy as ad-blocker for local network with many features"

	# shellcheck disable=1004,2016
	echo '
 _     _            _
| |__ | | ___   ___| | ___   _
| |_ \| |/ _ \ / __| |/ / | | |
| |_) | | (_) | (__|   <| |_| |
|_.__/|_|\___/ \___|_|\_\\__, |
                         |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	current_dir=${current_dir:?"current_dir must be set"}

	yay -Syu blocky
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	sudo cp "$current_dir/blocky/blocky.yml" /etc/blocky.yml

	sudo git clone "https://github.com/StevenBlack/hosts.git" /opt/hosts || (cd "/opt/hosts" && sudo git pull)
}
