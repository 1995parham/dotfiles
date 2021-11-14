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
	echo "i3 window manager for arch"
	# shellcheck disable=1004
	echo '
 _ _____
(_)___ /
| | |_ \
| |___) |
|_|____/
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

	msg 'i3 with polybar'
	sudo pacman -Syu --noconfirm --needed i3-gaps xclip gtk3
	yay -Syu --noconfirm --needed i3-scrot matcha-gtk-theme polybar i3exit

	configfile gtk-3.0 settings.ini i3
	configfile i3 "" i3
	configfile polybar "" i3

	msg 'ranger with image preview'
	sudo pacman -Syu --noconfirm --needed ranger ueberzug

	msg 'better brightness control with brightnessctl'
	sudo pacman -Syu --noconfirm --needed brightnessctl

	configfile ranger "" i3

	msg 'x11/wayland image viewer'
	sudo pacman -Syu --noconfirm --needed imv

	msg 'pdf viewer'
	sudo pacman -Syu --noconfirm --needed mupdf

	msg 'picom'
	sudo pacman -Syu --noconfirm --needed picom
	sudo pacman -Syu --noconfirm --needed unclutter
	configrootfile picom picom.conf i3

	msg 'x11/wayland image viewer'
	sudo pacman -Syu --noconfirm --needed imv

	msg 'pdf viewer'
	sudo pacman -Syu --noconfirm --needed mupdf

	msg 'notification with dunst'
	sudo pacman -Syu --noconfirm --needed dunst libnotify
	configfile dunst "" i3

	msg 'backgrounds with feh'
	sudo pacman -Syu --noconfirm --needed feh
	msg 'setup a systemd timer to change background images each 5 minutes with feh'
	configsystemd feh feh.timer i3
	configsystemd feh feh.service i3

	msg 'configure the dmenu, default application luncher on i3'
	linker dmenu "$current_dir/i3/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	msg 'configure rofi another application luncher'
	sudo pacman -Syu --noconfirm --needed rofi
	configfile rofi "" i3

	msg 'gnome-keyring/seahorse setup with ~/.profile'
	sudo pacman -Syu --noconfirm --needed gnome-keyring seahorse
	dotfile i3 profile
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$current_dir/i3/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

	msg 'pavucontrol, a panel for audio'
	sudo pacman -Syu --noconfirm --needed pavucontrol

	msg 'pulse-audio tray'
	sudo pacman -Syu --noconfirm --needed pasystray

	msg 'there is no power manager and all events will be handled by systemd'
	sudo cp "$current_dir/i3/systemd/logind.conf" /etc/systemd/logind.conf

	msg 'enable feh services later to be a good post installation script'
	systemctl --user enable feh.timer
	systemctl --user start feh.timer
}
