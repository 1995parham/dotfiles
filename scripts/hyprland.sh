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
	yay -Syu hyprland-git
	sudo pacman -Syu --noconfirm --needed waybar grim xdg-user-dirs wl-clipboard
	configfile hypr "" hyprland
	configfile waybar "" sway

	msg 'better hyprland with more keys [brightnessctl]'
	sudo pacman -Syu --noconfirm --needed brightnessctl

	msg 'required freedesktop services'
	sudo pacman -Syu --noconfirm --needed upower rtkit

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

	msg 'configure fuzzel as an another application luncher'
	sudo pacman -Syu --noconfirm --needed fuzzel

	msg 'we are going to have sound'
	sudo pacman -Syu --noconfirm --needed pulsemixer easyeffects

	msg 'configure the dmenu, default application luncher on manjaro i3 days'
	linker dmenu "$dotfiles_root/sway/dmenurc" "$HOME/.dmenurc"
	chmod +x "$HOME/.dmenurc"

	msg 'gnome-keyring/seahorse setup with ~/.profile'
	sudo pacman -Syu --noconfirm --needed gnome-keyring seahorse
	dotfile sway profile
	mkdir -p "$HOME/.gnupg"
	linker gnupg "$dotfiles_root/sway/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}
