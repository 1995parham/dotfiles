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
	echo "usage: hostname hostname"
}

hostname-change() {
	message "hostname In OVH datacenter please remember to disable cloud-init program"

	message "hostname Change hostname to $1"

	message "hostname hostname"
	sudo hostname $1

	message "hostname /etc/hosts"
	sudo sed -i 's/127.0.1.1.*/127.0.1.1\t'"$1"'/g' /etc/hosts

	message "hostname /etc/hostname"
	echo $1 | sudo tee /etc/hostname
}

main() {
        if [ -z "$1" ]; then
	        usage
	        return
        fi
        hostname-change $1
}
