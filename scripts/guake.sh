#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : guake.sh
#
# [] Creation Date : 23-04-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "guake drop-in terminal for gnome-based environments"
}

main_apt() {
	sudo apt install guake
}

main_pacman() {
	msg "there is nothing that we can do"
	return 1
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	configsystemd guake guake.service

	systemctl --user enable guake.service --now
}
