#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[node] This script must be run as root"
	exit 1
fi

echo "[node] Installing Node 6.x"

if [ "$OSTYPE" == "darwin"* ]; then
	brew install node
else
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	apt-get install -y nodejs
	ln -s /usr/bin/nodejs /usr/bin/node
fi

echo "[node] Installing jshint"
npm install -g jshint
