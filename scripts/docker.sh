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
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "[docker] Add docker apt repository"
echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/docker.list

echo "[docker] Installing docker !"
apt-get update
apt-get install docker-engine
service docker start

echo "[docker] Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
