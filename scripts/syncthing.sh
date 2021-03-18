#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : syncthing.sh
#
# [] Creation Date : 11-01-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

main() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		sudo pacman -Syu --needed --noconfirm syncthing
		sudo systemctl enable syncthing@parham
		sudo systemctl start syncthing@parham
	else
		brew install syncthing
		brew services start syncthing
	fi

	message "syncthing" "Please refer to its documentation for setup the mesh"
}
