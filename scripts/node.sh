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
	echo "usage: node"
}

node-install() {
	message "node" "Installing Node from brew"
	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "node" "Darwin"

		brew install node
	else
		message "node" "Linux"
		if [[ "$(command -v apt)" ]]; then
			echo "TODO"
		elif [[ "$(command -v pacman)" ]]; then
			message "node" "install node with pacman"
			sudo pacman -Syu --noconfirm --needed nodejs npm
		fi
	fi

	message "node" "$(node -v)"
}

main() {
	node-install
}
