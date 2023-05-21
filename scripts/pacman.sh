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
	copycat "pacman" "pacman/mirrorlist" /etc/pacman.d/mirrorlist
	copycat "pacman" "pacman/makepkg.conf" /etc/makepkg.conf
}
