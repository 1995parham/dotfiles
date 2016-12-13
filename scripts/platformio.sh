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
