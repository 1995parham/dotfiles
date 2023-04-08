#!/bin/bash

usage() {
	echo -n 'my dns, my rules (remember systemd is the best)'
	echo '
     _
  __| |_ __  ___
 / _| | |_ \/ __|
| (_| | | | \__ \
 \__,_|_| |_|___/
  '
}

main_pacman() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg "systemd-resolved will work out of the box with a network manager using /etc/resolv.conf."
	sudo systemctl enable --now systemd-resolved

	sudo mkdir -p "/etc/systemd/resolved.conf.d/" || true

	PS3="select shecan installation kind:"

	kinds=(
		"shecan: public and free version of shecan accessible from everywhere"
		"shecan-pro: private and pro version of shecan accessible from home only"
	)

	select kind in "${kinds[@]}"; do
		kind=${kind%%:*}
		msg "installing $kind..."
		break
	done

	sudo cp "$dotfiles_root/dns/$kind.conf" "/etc/systemd/resolved.conf.d/$kind.conf"

	if [ "$(curl -s check.shecan.ir)" = '0' ]; then
		msg "shecan is ready"
	fi
}
