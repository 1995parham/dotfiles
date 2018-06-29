#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : asm.sh
#
# [] Creation Date : 30-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[asm] This script must be run as root"
	exit 1
fi
apt-get install nasm radare2
