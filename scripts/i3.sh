#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : i3.sh
#
# [] Creation Date : 18-11-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "i3 window manager for manajaro i3"
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed i3-gaps i3-scrot polybar

	configfile i3 "" i3
	configfile polybar "" i3

	sudo pacman -Syu --noconfirm --needed picom
	sudo pacman -Syu --noconfirm --needed unclutter
	configrootfile picom picom.conf i3
	sudo pacman -Syu --noconfirm --needed nitrogen
	sudo pacman -Syu --noconfirm --needed dunst
	# use manjaro-i3 appearance-menu for changing the gtk theme
	# sudo pacman -Syu --noconfirm --needed lxappearance
	configfile dunst "" i3

	msg 'setup a systemd timer to change background images each 5 minutes with nitrogen'
	configsystemd nitrogen nitrogen.timer i3
	configsystemd nitrogen nitrogen.service i3

	systemctl --user enable nitrogen.timer
	systemctl --user start nitrogen.timer

	msg 'configure the dmenu, default application luncher on manjaro i3'
	linker dmenu "$current_dir/i3/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	msg 'configure rofi another application luncher'
	sudo pacman -Syu --noconfirm --needed rofi
	configfile rofi "" i3

	linker gtk-2.0 "$current_dir/i3/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
	configfile gtk-3.0 settings.ini i3

	sudo pacman -Syu --noconfirm --needed perl-anyevent-i3
}
