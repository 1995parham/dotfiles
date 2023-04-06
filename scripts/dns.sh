#!/bin/bash

usage() {
	echo -n 'my dns, my rules'
}

main_pacman() {
	msg "systemd-resolved will work out of the box with a network manager using /etc/resolv.conf."
	sudo systemctl enable --now systemd-resolved

	sudo mkdir -p "/etc/systemd/resolved.conf.d/" || true
	sudo cp "$dotfiles_root/dns/shecan.conf" "/etc/systemd/resolved.conf.d/shecan.conf"
}
