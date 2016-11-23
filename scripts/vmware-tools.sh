#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : vmware-tools.sh
#
# [] Creation Date : 07-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[vmware-tools] This script must be run as root"
	exit 1
fi

echo "[vmware-tools] Installing open-vm-tools"

apt-get install open-vm-tools

echo "[vmware-tools] Configuring open-vm-tools"

update-rc.d open-vm-tools defaults
update-rc.d open-vm-tools enable
