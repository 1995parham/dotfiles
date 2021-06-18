#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : kitty.sh
#
# [] Creation Date : 23-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n 'full-flagged terminal'

	echo '
 _    _ _   _
| | _(_) |_| |_ _   _
| |/ / | __| __| | | |
|   <| | |_| |_| |_| |
|_|\_\_|\__|\__|\__, |
                |___/
  '
}

main_apt() {
	sudo apt install kitty
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm kitty
}

main_brew() {
	brew install --cask kitty
}

main() {
	configfile kitty
}
