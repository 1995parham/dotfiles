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
	if yes_or_no 'sway' 'do you want to use stable release?'; then
		not_require_pacman sway-git swaylock-git wlroots-git swayidle-git swaybg-git sway-git-debug wlroots-git-debug
		require_pacman sway wlroots swaylock swayidle swaybg
	else
		not_require_pacman sway swaylock wlroots swayidle swaybg
		require_aur sway-git wlroots-git swaylock-git swayidle-git swaybg-git
	fi

	copycat "sway" archinstall/sway.d/sway.desktop /usr/share/wayland-sessions/sway.desktop
	copycat "sway" archinstall/sway.d/sway.sh /usr/local/bin/sway.sh

	require_pacman xdg-desktop-portal-wlr

	configfile sway "" sway
	configfile swaylock "" sway
	sudo usermod -aG input "$USER"

	msg 'you can install sway-git with wlroots-git in the future'

	msg 'dynamic display configuration'
	require_pacman kanshi
	configfile kanshi "" sway

	msg 'setup user-systemd services'
	configsystemd services kanshi.service sway
	configsystemd services workspaces.service sway
	configsystemd services bg.service sway
}
