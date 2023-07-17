#!/bin/bash

usage() {
	echo 'pacman configuraiton for arch here and now'

	echo '
 _ __   __ _  ___ _ __ ___   __ _ _ __
| |_ \ / _| |/ __| |_ | _ \ / _| | |_ \
| |_) | (_| | (__| | | | | | (_| | | | |
| .__/ \__,_|\___|_| |_| |_|\__,_|_| |_|
|_|
  '
}

main_pacman() {
	copycat "pacman" "pacman/pacman.conf" /etc/pacman.conf
	copycat "pacman" "pacman/makepkg.conf" /etc/makepkg.conf
	if yes_or_no 'do you want to update mirrorlist'; then
		copycat "pacman" "pacman/mirrorlist" /etc/pacman.d/mirrorlist
	fi
}
