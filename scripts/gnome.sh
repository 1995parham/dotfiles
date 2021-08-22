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
	msg 'enable fractional scaling to have more space, you need to restart and then you can change it from settings'
	gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

	msg 'show weekday besides the 24h clock on menubar'
	gsettings set org.gnome.desktop.interface clock-show-weekday true
	gsettings set org.gnome.desktop.interface clock-format "'24h'"

	msg 'show battery percentage on menubar'
	gsettings set org.gnome.desktop.interface show-battery-percentage true

	msg 'touchpad in my way'
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
	gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
	gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true

	msg 'keybinding for me, not anyone else'
	for i in $(seq 1 9); do
		gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
		gsettings set org.gnome.shell.keybindings "switch-to-application-$i" "[]"
	done

	msg '8 workspaces is useful for me'
	gsettings set org.gnome.desktop.wm.preferences num-workspaces 8
	gsettings set org.gnome.desktop.wm.preferences workspace-names "['main-1', 'main-2', 'emacs', 'www', 'vm', 'apps-1', 'apps-2', 'social']"

	msg 'small text is better'
	gsettings set org.gnome.desktop.interface text-scaling-factor 0.95

	msg 'have two input source for us and ir'
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ir')]"
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
