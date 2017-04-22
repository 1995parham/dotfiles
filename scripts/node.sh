#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
echo "[node] Installing Node 6.x"

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[node] Darwin"

	brew install node
else
	echo "[node] Linux"

	if [[ $EUID -ne 0 ]]; then
		echo "[node] This script must be run as root"
		exit 1
	fi

	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	apt-get install -y nodejs
	ln -s /usr/bin/nodejs /usr/bin/node
fi

echo "[node] Installing jshint"
npm install -g jshint
