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

	copycat "dns" "dns/$kind.conf" "/etc/systemd/resolved.conf.d/shecan.conf"
	sudo systemctl restart systemd-resolved

	if [ "$(curl -s check.shecan.ir)" = '0' ]; then
		msg "shecan is ready"
	else
		msg 'shecan is not working' 'error'
		return 1
	fi

	if [ -d "/etc/docker" ]; then
		sudo touch /etc/docker/daemon.json
		dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

		msg 'merge dns configuration for docker with system current configuration'
		r=$(jq -s '.[0] * (.[1] // {})' "$dotfiles_root/dns/$kind-docker.json" "/etc/docker/daemon.json")
		echo "$r" | sudo tee "/etc/docker/daemon.json"
	fi
}
