#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : hostname.sh
#
# [] Creation Date : 27-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

program_name=$0

usage() {
	echo "usage: $program_name hostname"
}

change_hostname() {
	echo "[hostname] In OVH datacenter please remember to disable cloud-init program"

	echo "[hostname] Change hostname to $1"

	echo "[hostname] hostname"
	hostname $1

	echo "[hostname] /etc/hosts"
	sed -i 's/127.0.1.1.*/127.0.1.1\t'"$1"'/g' /etc/hosts

	echo "[hostname] /etc/hostname"
	echo $1 > /etc/hostname
}

if [[ $EUID -ne 0 ]]; then
	echo "[hostname] This script must be run as root"
	exit 1
fi

if [ -z "$1" ]; then
	usage
	exit 1
fi
change_hostname $1
