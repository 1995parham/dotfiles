#!/bin/bash

usage() {
	echo "i3-compatible Wayland compositor"
	# shellcheck disable=1004,2028
	echo '
 _____      ____ _ _   _
/ __\ \ /\ / / _| | | | |
\__ \\ V  V / (_| | |_| |
|___/ \_/\_/ \____|\___ |
                   |___/
  '
}

main_pacman() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg 'install and configure sway, swaylock and waybar'
	require_pacman swaylock swayidle grim xdg-user-dirs wl-clipboard noto-fonts swaybg
	require_aur waybar-git
	require_pacman xdg-desktop-portal-wlr xdg-utils
	require_pacman sway
	# require_aur wlroots-git sway-git
	require_pacman xorg-xwayland
	configfile sway "" sway
	configfile swaylock "" sway
	configfile waybar "" sway

	msg 'you can install sway-git with wlroots-git in the futureu'

	msg 'better sway with more keys [brightnessctl]'
	require_pacman brightnessctl

	msg 'required freedesktop services'
	require_pacman upower rtkit

	msg 'gtk3 theme'
	require_aur matcha-gtk-theme
	configfile gtk-3.0 settings.ini sway

	msg 'qt support'
	require_pacman qt5-wayland

	msg 'imv as image viewer (not working with sway-git)'
	require_pacman imv

	msg 'mupdf as pdf viewer'
	require_pacman mupdf

	msg 'notification with dunst'
	require_pacman dunst libnotify
	configfile dunst "" sway

	# msg 'backgrounds with swaybg'
	# require_pacman swaybg

	msg 'a window switcher, application launcher and dmenu replacement (fork with Wayland support)'
	require_aur rofi-lbonn-wayland-git
	configfile rofi "" sway

	msg 'we are going to have sound'
	require_pacman pulsemixer easyeffects

	msg 'configure the dmenu, default application luncher from manjaro i3 days'
	linker dmenu "$dotfiles_root/sway/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	# msg 'allow run gui application with sudo (e.g. gparted)'
	# xhost +SI:localuser:root

	msg 'gnome-keyring/seahorse setup with ~/.profile'
	require_pacman gnome-keyring seahorse
	dotfile sway profile
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$dotfiles_root/sway/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
