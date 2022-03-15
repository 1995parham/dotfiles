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
	sudo pacman -Syu --noconfirm --needed sway swaylock swayidle waybar grim xdg-user-dirs wl-clipboard
	configfile sway "" sway
	configfile swaylock "" sway
	configfile waybar "" sway

	msg 'better sway with more keys [brightnessctl]'
	sudo pacman -Syu --noconfirm --needed brightnessctl

	msg 'required freedesktop services'
	sudo pacman -Syu --noconfirm --needed upower

	msg 'featurerich screenshot tool'
	sudo pacman -Syu --noconfirm --needed flameshot

	msg 'gtk theme'
	yay -Syu --noconfirm --needed matcha-gtk-theme
	configfile gtk-3.0 settings.ini sway

	msg 'qt support'
	sudo pacman -Syu --noconfirm --needed qt5-wayland

	msg 'x11/wayland image viewer'
	sudo pacman -Syu --noconfirm --needed imv

	msg 'pdf viewer'
	sudo pacman -Syu --noconfirm --needed mupdf

	msg 'notification with dunst'
	sudo pacman -Syu --noconfirm --needed dunst libnotify
	configfile dunst "" sway

	msg 'backgrounds with swaybg'
	msg 'setup a systemd timer to change background images each 5 minutes with swaybg'
	sudo pacman -Syu --noconfirm --needed swaybg

	msg 'configure wofi as an another application luncher'
	sudo pacman -Syu --noconfirm --needed wofi
	configfile wofi "" sway

	msg 'configure the dmenu, default application luncher on manjaro i3'
	linker dmenu "$current_dir/sway/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	msg 'gnome-keyring/seahorse setup with ~/.profile'
	sudo pacman -Syu --noconfirm --needed gnome-keyring seahorse
	dotfile sway profile
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$current_dir/i3/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
