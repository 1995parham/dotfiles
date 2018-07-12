#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : $file.name
#
# [] Creation Date : $time.strftime("%d-%m-%Y")
#
# [] Created By : $user.name ($user.email)
# =======================================
echo "[c] Installing clang + cmake"

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[c] Darwin"

	brew install clang-foramt
        brew install cmake
else
	echo "[c] Linux"

	if [[ $EUID -ne 0 ]]; then
		echo "[c] This script must be run as root"
		exit 1
	fi

        apt-get install clang clang-format
        apt-get install cmake
fi
