#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
echo "[node] Installing Node 8.x"

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[node] Darwin"

	brew install node
	brew install yarn
else
	echo "[node] Linux"

	if [[ $EUID -ne 0 ]]; then
		echo "[node] This script must be run as root"
		exit 1
	fi

	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	apt-get install -y nodejs
	ln -s /usr/bin/nodejs /usr/bin/node

	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	
	apt-get update && apt-get install yarn
fi

echo "[node] Installing PM2 - the industry-standard task runner"
npm install -g pm2
