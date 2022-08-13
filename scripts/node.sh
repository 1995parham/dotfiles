#!/bin/bash

usage() {
	echo "install nodejs, remembers language-servers must of the time needs nodejs"
	# shellcheck disable=1004
	echo '
                 _
 _ __   ___   __| | ___
| |_ \ / _ \ / _| |/ _ \
| | | | (_) | (_| |  __/
|_| |_|\___/ \__|_|\___|

  '
}

main_brew() {
	msg "installing node from brew"
	brew install node
}

main_apt() {
	msg "installing node from its official apt repository"
	curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
	sudo apt-get install -y nodejs

}

main_pacman() {
	message "node" "install node with pacman"
	require_pacman nodejs npm
}

main() {
	msg "$(node -v)"
}
