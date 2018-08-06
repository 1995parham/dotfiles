#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : env.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[env] Darwin"

	brew install zsh ctags vim tmux mosh aria2
	brew install neovim
	pip3 install --upgrade neovim
	brew install yamllint
	
	gem install travis -v 1.8.8 --no-rdoc --no-ri
else
	echo "[env] Linux"

	if [[ $EUID -ne 0 ]]; then
		echo "[env] This script must be run as root"
		exit 1
	fi

	apt-get update -q
	apt-get install zsh ctags vim tmux mosh aria2 jq yamllint curl -y

	add-apt-repository ppa:neovim-ppa/stable -y
	apt-get update -q
	apt-get install neovim -y
	apt-get install python3-dev python3-pip -y
	pip3 install --upgrade neovim

	# gem install travis -v 1.8.8 --no-rdoc --no-ri
fi
