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
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg 'update /etc/pacman.conf'
	sudo cp "$dotfiles_root/pacman/pacman.conf" /etc/pacman.conf

	msg 'update /etc/makepkg.conf'
	sudo cp "$dotfiles_root/pacman/makepkg.conf" /etc/makepkg.conf
}
