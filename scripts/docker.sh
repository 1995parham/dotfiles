#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : docker.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[docker] This script must be run as root"
	exit 1
fi

echo "[docker] Installing tools for apt repository management"
apt-get update
apt-get install apt-transport-https ca-certificates

echo "[docker] Add net GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "[docker] Add docker apt repository"
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

echo "[docker] Installing docker"
apt-get update
apt-get install docker-cs
echo "[docker] The Docker daemon starts automatically."

echo "[docker] Installing docker-compose"
if [ ! -e /usr/local/bin/docker-compose ]; then
	curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
fi
