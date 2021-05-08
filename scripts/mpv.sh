#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : mpv.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: mpv"
	echo '
 _ __ ___  _ ____   __
| |_ ` _ \| |_ \ \ / /
| | | | | | |_) \ V /
|_| |_| |_| .__/ \_/
          |_|
  '
}

main_brew() {
	brew install --cask mpv
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed mpv
}

main() {
	configfile mpv
}
