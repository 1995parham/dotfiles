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
	echo "sway window manager for arch, from scratch"
	# shellcheck disable=1004
	echo '
 _____      ____ _ _   _
/ __\ \ /\ / / _` | | | |
\__ \\ V  V / (_| | |_| |
|___/ \_/\_/ \__,_|\__, |
                   |___/
  '
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	current_dir=${current_dir:?"current_dir must be set"}

	msg 'sway'
	sudo pacman -Syu --noconfirm --needed sway swaylock swayidle waybar grim
	configfile sway "" sway

	msg 'x11/wayland image viewer'
	sudo pacman -Syu --noconfirm --needed imv

	sudo pacman -Syu --noconfirm --needed unclutter

	msg 'notification with dunst'
	sudo pacman -Syu --noconfirm --needed dunst
	configfile dunst "" sway

	msg 'backgrounds with swaybg'
	msg 'setup a systemd timer to change background images each 5 minutes with swaybg'
	sudo pacman -Syu --noconfirm --needed swaybg

	configsystemd swaybg swaybg.timer sway
	configsystemd swaybg swaybg.service sway
	configfile swaybg gosimac.sh sway

	systemctl --user enable swaybg.timer
	systemctl --user start swaybg.timer

	msg 'configure rofi as an another application luncher'
	sudo pacman -Syu --noconfirm --needed rofi
	configfile rofi "" sway

	msg 'configure the dmenu, default application luncher on manjaro i3'
	linker dmenu "$current_dir/sway/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"
}
