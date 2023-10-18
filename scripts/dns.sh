#!/bin/bash

usage() {
	echo -n 'my dns, my rules (based on dnsmasq)'
	echo '
     _
  __| |_ __  ___
 / _| | |_ \/ __|
| (_| | | | \__ \
 \__,_|_| |_|___/
  '
}

declare -A primary_shecan_dns
primary_shecan_dns["shecan-pro"]="178.22.122.101"
primary_shecan_dns["shecan"]="178.22.122.100"

declare -A secondary_shecan_dns
secondary_shecan_dns["shecan-pro"]="185.51.200.1"
secondary_shecan_dns["shecan"]="185.51.200.2"

main_pacman() {
	require_pacman dnsmasq

	copycat "dns" "dns/dns.conf" "/etc/NetworkManager/conf.d/dns.conf"
	msg 'NetworkManager will automatically start dnsmasq and add 127.0.0.1 to /etc/resolv.conf'
	sudo nmcli general reload

	PS3="select shecan installation kind:"

	kinds=(
		"shecan: public and free version of shecan accessible from everywhere"
		"shecan-pro: private and pro version of shecan accessible from home only"
		"none: no shecan"
	)

	select kind in "${kinds[@]}"; do
		kind=${kind%%:*}
		msg "installing $kind..."
		break
	done

	if [ -f "/etc/NetworkManager/dnsmasq.d/shecan.conf" ]; then
		sudo rm '/etc/NetworkManager/dnsmasq.d/shecan.conf'
	fi

	if [ "$kind" != none ]; then
		root=${root:?"root must be set"}
		for f in "$root/dns/domains-$kind".*; do
			mapfile -t domains <<<"$(cat "$f")"
			domains_dnsmasq="$(printf '/%s' "${domains[@]}")"
			echo -e "server=$domains_dnsmasq/${primary_shecan_dns[$kind]}\nserver=$domains_dnsmasq/${secondary_shecan_dns[$kind]}" |
				sudo tee -a /etc/NetworkManager/dnsmasq.d/shecan.conf
		done
	fi

	copycat "dns" dns/1995parham.conf /etc/NetworkManager/dnsmasq.d/1995parham.conf

	dnsmasq --test --conf-file=/dev/null --conf-dir=/etc/NetworkManager/dnsmasq.d
	sudo nmcli general reload

	if [ "$kind" != none ]; then
		msg 'validate your access to the shecan infrastructure'

		if [ "$(curl -s check.shecan.ir)" = '0' ]; then
			msg "shecan is ready"
		else
			msg 'shecan is not working' 'error'
			return 1
		fi

		msg 'use shecan to in the docker containers'
		if [ -d "/etc/docker" ]; then
			sudo touch /etc/docker/daemon.json

			msg 'merge dns configuration for docker with system current configuration'
			r=$(jq -s '.[0] * (.[1] // {})' "$root/dns/$kind-docker.json" "/etc/docker/daemon.json")
			echo "$r" | sudo tee "/etc/docker/daemon.json"
		fi
	fi
}
