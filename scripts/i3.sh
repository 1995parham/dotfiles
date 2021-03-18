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
	echo "usage: i3"
}

main() {
	# Reset optind between calls to getopts
	OPTIND=1

	sudo pacman -Syu --noconfirm --needed i3-gaps i3-scrot i3status-rust

	configfile i3status "" i3
	configfile i3 "" i3

	sudo pacman -Syu --noconfirm --needed picom
	configrootfile picom picom.conf i3
	sudo pacman -Syu --noconfirm --needed nitrogen
	sudo pacman -Syu --noconfirm --needed dunst
	# use manjaro-i3 appearance-menu for changing the gtk theme
	# sudo pacman -Syu --noconfirm --needed lxappearance
	configfile dunst "" i3

	configsystemd nitrogen nitrogen.timer i3
	configsystemd nitrogen nitrogen.service i3

	systemctl --user enable nitrogen.timer
	systemctl --user start nitrogen.timer

	linker dmenu $current_dir/i3/dmenurc $HOME/.dmenurc
	chmod +x $HOME/.dmenurc

	linker gtk-2.0 $current_dir/i3/gtk-2.0/gtkrc-2.0 $HOME/.gtkrc-2.0
	configfile gtk-3.0 settings.ini i3

	sudo pacman -Syu --noconfirm --needed perl-anyevent-i3
}
