#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : platformio.sh
#
# [] Creation Date : 13-12-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[platformio] This script must be run as root"
	exit 1
fi

echo "[platformio] Installing PlatformIO"
pip2 install -U platformio

echo "[platformio] Installing udev rules"
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/99-platformio-udev.rules > /etc/udev/rules.d/99-platformio-udev.rules
udo service udev restart
