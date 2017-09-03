#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
echo "[python] Installing Python 3.x"

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[python] Darwin"

	brew install python3
else
	echo "[python] Linux"

	if [[ $EUID -ne 0 ]]; then
		echo "[python] This script must be run as root"
		exit 1
	fi

	apt-get install python3 python3-venv python3-pip
fi

echo "[python] Installing flake-8 pep8-naming sphinx"

pip3 install flake8
pip3 install pep8-naming
pip3 install pipenv
