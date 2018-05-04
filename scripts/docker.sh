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

echo "[docker] HTTP Proxy, for those who lives in Iran"
export http_proxy=http://fod.backtory.com:8118/
export https_proxy=http://fod.backtory.com:8118/

echo "[docker] Installing tools for apt repository management"
apt-get -q update
apt-get install apt-transport-https ca-certificates

echo "[docker] Add net GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "[docker] Add docker apt repository"
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

echo "[docker] Installing docker"
apt-get -q update
apt-get install docker-ce
echo "[docker] The Docker daemon starts automatically."

echo "[docker] Docker in futherland"
cat > /etc/docker/daemon.json << "EOF"
{
  "registry-mirrors": [
      "http://mirror.docker.cloud.aut.ac.ir",
      "http://repo.docker.ir:5000"
  ],
  "dns": ["8.8.8.8", "8.8.4.4"]
}
EOF
systemctl restart docker

echo "[docker] Manage Docker as a non-root user"
groupadd docker
usermod -aG docker parham

compose_vr=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
compose_vl=$(docker-compose version --short)

if [ "${compose_vl}" != "${compose_vr}" ]; then
	echo "[docker] Installing docker-compose"
	curl -L "https://github.com/docker/compose/releases/download/${compose_vr}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
fi

echo "[docker] HTTP Proxy, for those who lives in Iran"
unset http_proxy
unset https_proxy
