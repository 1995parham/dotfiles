#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
version="10.x"
echo "[node] Installing Node $version"

if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "[node] Darwin"

	brew install node
	brew install yarn
else
	echo "[node] Linux"

	curl -sL https://deb.nodesource.com/setup_$version | sudo -E bash -
	sudo apt-get install -y nodejs
	ln -s /usr/bin/nodejs /usr/bin/node
fi

echo "[node] Installing PM2 - the industry-standard task runner"
npm install -g pm2

echo "[node] Installing Newman - Modern software is built on APIs. Postman helps you develop APIs faster."
npm install -g newman
