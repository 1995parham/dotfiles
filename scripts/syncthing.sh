#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : syncthing.sh
#
# [] Creation Date : 11-01-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo 'synthing is awesome'
	echo '
                      _   _     _
 ___ _   _ _ __   ___| |_| |__ (_)_ __   __ _
/ __| | | | |_ \ / __| __| |_ \| | |_ \ / _` |
\__ \ |_| | | | | (__| |_| | | | | | | | (_| |
|___/\__, |_| |_|\___|\__|_| |_|_|_| |_|\__, |
     |___/                              |___/
  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm syncthing
	sudo systemctl enable syncthing@parham
	sudo systemctl start syncthing@parham
}

main_brew() {
	brew install syncthing
	brew services start syncthing
}

main_apt() {
	return 1
}

main() {
	msg "systems can connect to each other, in parham architecture all of them connect to one main server"
	msg "disable [Enable Relaying] [Global Discovery] [Enable NAT traversal] in [Connections] tab to reduce overhead."
}
