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

root=${root:?"root must be set"}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	msg 'install and configure hyperland and waybar'
	require_pacman hyprland
	require_pacman grim xdg-user-dirs wl-clipboard swayidle
	require_aur waybar-git
	configfile hypr "" hyprland
	configfile waybar "" hyprland
}
