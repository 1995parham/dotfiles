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
	copycat "dns" "dns/dns.conf" "/etc/NetworkManager/conf.d/dns.conf"
	msg 'NetworkManager will automatically start dnsmasq and add 127.0.0.1 to /etc/resolv.conf'
	sudo nmcli general reload

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

	copycat "dns" "dns/$kind.conf" "/etc/NetworkManager/dnsmasq.d/shecan.conf"
	dnsmasq --test --conf-file=/dev/null --conf-dir=/etc/NetworkManager/dnsmasq.d
	sudo nmcli general reload

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
