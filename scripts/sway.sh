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
	msg 'install and configure sway and swaylock'
	require_pacman swaylock swayidle swaybg
	require_pacman xdg-desktop-portal-wlr
	require_pacman sway
	configfile sway "" sway
	configfile swaylock "" sway
	sudo usermod -aG input "$USER"

	msg 'you can install sway-git with wlroots-git in the future'

	msg 'dynamic display configuration'
	require_pacman kanshi
	configfile kanshi "" sway
}
