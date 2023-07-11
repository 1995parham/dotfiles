#!/bin/bash

export additionals=(wayland)

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

root=${root:?"root must be set"}

main_pacman() {
	require_pacman llvm

	msg 'install and configure sway, swaylock and waybar'
	require_pacman swaylock swayidle grim xdg-user-dirs wl-clipboard noto-fonts swaybg
	require_aur waybar-git
	require_pacman sway
	require_pacman xorg-xwayland
	configfile sway "" sway
	configfile swaylock "" sway
	configfile waybar "" sway
	sudo usermod -aG input "$USER"

	msg 'you can install sway-git with wlroots-git in the future'
}
