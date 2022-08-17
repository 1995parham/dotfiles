#!/bin/bash

usage() {
	echo "Hyprland is a dynamic tiling Wayland compositor that doesn't sacrifice on its looks."
	# shellcheck disable=1004
	echo '
 _                      _                 _
| |__  _   _ _ __  _ __| | __ _ _ __   __| |
| |_ \| | | | |_ \| |__| |/ _| | |_ \ / _| |
| | | | |_| | |_) | |  | | (_| | | | | (_| |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
       |___/|_|
  '
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg 'hyprland'
	require_aur hyprland-git
	require_pacman grim xdg-user-dirs wl-clipboard
	require_aur waybar-hyprland-git
	configfile hypr "" hyprland
	configfile waybar "" hyprland

	msg 'better hyprland with more keys [brightnessctl]'
	require_pacman brightnessctl

	msg 'required freedesktop services'
	require_pacman upower rtkit

	msg 'featurerich screenshot tool'
	require_pacman flameshot

	msg 'gtk theme'
	require_aur matcha-gtk-theme
	configfile gtk-3.0 settings.ini sway

	msg 'qt support'
	require_pacman qt5-wayland

	msg 'x11/wayland image viewer'
	require_pacman imv

	msg 'pdf viewer'
	require_pacman mupdf

	msg 'notification with dunst'
	require_pacman dunst libnotify
	configfile dunst "" sway

	msg 'configure fuzzel as an another application luncher'
	require_pacman fuzzel

	msg 'we are going to have sound'
	require_pacman pulsemixer easyeffects

	msg 'configure the dmenu, default application luncher on manjaro i3 days'
	linker dmenu "$dotfiles_root/sway/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	msg 'gnome-keyring/seahorse setup with ~/.profile'
	require_pacman gnome-keyring seahorse
	dotfile sway profile
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$dotfiles_root/sway/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
