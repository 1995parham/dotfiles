#!/bin/bash

usage() {
	echo "Nix is a purely functional package manager that aims to make package management reliable and reproducible. "

	# shellcheck disable=1004,2016
	echo '
       _
 _ __ (_)_  __
| |_ \| \ \/ /
| | | | |>  <
|_| |_|_/_/\_\

  '
}

main_pacman() {
	require_pacman nix

	msg 'nix-daemon service with systemd'
	sudo systemctl enable --now nix-daemon.service

	msg "add required users to the nix-users group in order to access the daemon socket"
	sudo usermod -aG nix-users "$USER"

	msg 'manually add current user into nix-users group'
	# newgrp nix-users

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg 'create configuration on /etc/nix/nix.conf by copying it'
	sudo cp "$dotfiles_root/nix/nix.conf" /etc/nix/nix.conf
}

main() {
	msg 'add channels and update it'
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	nix-channel --update
}
