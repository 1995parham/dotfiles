#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
usage() {
	echo "install nodejs, remembers neovim-coc always needs nodejs"
}

main_brew() {
	msg "installing node from brew"
	brew install node
}

main_apt() {
	msg "installing node from its official apt repository"
	curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
	sudo apt-get install -y nodejs

}

main_pacman() {
	message "node" "install node with pacman"
	sudo pacman -Syu --noconfirm --needed nodejs npm
}

main() {
	msg "$(node -v)"
}
