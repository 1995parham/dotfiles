#!/usr/bin/env bash

usage() {
	echo "i3 window manager for arch"

	echo '
 _ _____
(_)___ /
| | |_ \
| |___) |
|_|____/
  '
}

export additionals=(x11)

root=${root:?"root must be set"}

main_pacman() {
	configfile awesome "" awesome

	msg 'install awesome with nice tools'
	require_pacman awesome picom redshift unclutter xfce4-power-manager acpi
	require_aur i3exit matcha-gtk-theme

	msg
	msg 'configure rofi another application luncher'
	require_pacman rofi
	configfile rofi "" awesome
}
