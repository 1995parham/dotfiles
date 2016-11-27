#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : hostname.sh
#
# [] Creation Date : 27-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[hostname] This script must be run as root"
	exit 1
fi

new_hostname=$1

echo "[hostname] Change hostname to $new_hostname"

echo "[hostname] hostname"
hostname $new_hostanme

echo "[hostname] /etc/hosts"
sed -i 's/127.0.1.1.*/127.0.1.1\t'"$new_hostname"'/g' /etc/hosts

echo "[hostname] /etc/hostname"
echo $new_hostname > /etc/hostname
