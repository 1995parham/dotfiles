#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "gnome desktop on wayland for arch"

	# shellcheck disable=1004,2016
	echo '
  __ _ _ __   ___  _ __ ___   ___
 / _` | |_ \ / _ \| |_ ` _ \ / _ \
| (_| | | | | (_) | | | | | |  __/
 \__, |_| |_|\___/|_| |_| |_|\___|
 |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	msg 'enable fractional scaling to have more space'
	gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

	msg 'show weekday besides the clock on menubar'
	gsettings set org.gnome.desktop.interface clock-show-weekday true

	msg 'show battery percentage on menubar'
	gsettings set org.gnome.desktop.interface show-battery-percentage true

	msg 'natrual scrolling'
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

	msg 'keybinding for me, not anyone else'

	for i in $(seq 1 10); do
		gsettings set "org.gnome.desktop.wm.keybindings switch-to-workspace-$i" "['<Super>$i']"
		gsettings set "org.gnome.shell.keybindings switch-to-application-$i" "[]"
	done
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
