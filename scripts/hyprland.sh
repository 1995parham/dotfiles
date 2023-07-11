#!/bin/bash

export additionals=(wayland)

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

main_pacman() {
	msg 'install and configure hyperland, hyprpaper and swaylock'
	# https://www.reddit.com/r/hyprland/comments/14mx8rj/screen_lock/
	require_pacman hyprland hyprpaper swaylock
	require_pacman xdg-desktop-portal-hyprland
	configfile hypr "" hyprland
	configfile waybar "" hyprland
	configfile swaylock "" hyprland
}
