#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : powershell.sh
#
# [] Creation Date : 21-06-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[powershell] This script must be run as root"
	exit 1
fi


echo "[powershell] Getting version information"
powershell_v=$(curl -s https://api.github.com/repos/powershell/powershell/releases/latest | grep 'tag_name' | cut -d\" -f4)

echo "[powershell] Installing powershell core $powershell_v"
curl -L --progress-bar "https://github.com/powershell/powershell/releases/download/${powershell_v}/Powershell-${powershell_v:1}-x86_64.AppImage" -o /usr/local/bin/powershell
chmod +x /usr/local/bin/powershell
