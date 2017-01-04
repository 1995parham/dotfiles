#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : tshark.sh
#
# [] Creation Date : 05-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[tshark] This script must be run as root"
	exit 1
fi

echo "[tshark] Installing tshark"

sudo apt-get install tshark
sudo dpkg-reconfigure wireshark-common
sudo adduser $USER wireshark
