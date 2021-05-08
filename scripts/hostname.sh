#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : hostname.sh
#
# [] Creation Date : 27-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
	echo "change your hostname"
	# shellcheck disable=1004,2016
	echo '
 _               _
| |__   ___  ___| |_ _ __   __ _ _ __ ___   ___
| |_ \ / _ \/ __| __| |_ \ / _` | |_ ` _ \ / _ \
| | | | (_) \__ \ |_| | | | (_| | | | | | |  __/
|_| |_|\___/|___/\__|_| |_|\__,_|_| |_| |_|\___|

	'
}

hostname-change() {
	msg "change hostname to $1"

	msg "hostnamectl"
	sudo hostnamectl set-hostname "$1"

	msg "/etc/hosts"
	sudo sed -i 's/127.0.1.1.*/127.0.1.1\t'"$1"'/g' /etc/hosts

	if [ -f /etc/cloud/cloud.cfg ]; then
		msg "/etc/cloud/cloud.cfg"
		sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
	fi

	msg "/etc/hostname"
	echo "$1" | sudo tee /etc/hostname
}

main() {
	if [ -z "$1" ]; then
		usage
		return
	fi
	hostname-change "$1"
}
