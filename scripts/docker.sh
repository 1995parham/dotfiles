#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : docker.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

program_name=$0

have_proxy=false
verbose=false

usage() {
	echo "usage: $program_name [-i] [-h] [-p] [-v]"
	echo "  -i   install and initiate docker"
	echo "  -p   use parham-usvs proxy for installation"
	echo "  -v   verbose"
	echo "  -h   display help"
}

set_proxy() {
	echo "[docker] set parham-usvs proxy"

	ssh -fTN -L 38080:127.0.0.1:38080 $parham_usvs
	export {http,https,ftp}_proxy=127.0.0.1:38080
}

unset_proxy() {
	echo "[docker] unset parham-usvs proxy"

	ps aux | grep "ssh -fTN" | grep "38080:" | awk '{print $2}' | xargs kill
	unset {http,https,ftp}_proxy
}

install_docker_repository() {
	echo "[docker] Installing tools for apt repository management"
	apt-get -q update
	apt-get install apt-transport-https ca-certificates

	echo "[docker] Add new GPG key"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	echo "[docker] Add docker apt repository"
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
}

install_docker() {
	echo "[docker] Installing docker"
	apt-get -q update
	apt-get install docker-ce
	echo "[docker] The Docker daemon starts automatically."

	echo "[docker] Manage Docker as a non-root user"
	groupadd docker
	usermod -aG docker parham
}

futherland_docker() {
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
}

update_docker() {
	apt-get -q update
	apt-get install docker-ce
}

install_update_docker_compose() {
	compose_vr=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
	compose_vl=$(docker-compose version --short)

	if [ "${compose_vl}" != "${compose_vr}" ]; then
		echo "[docker] Installing docker-compose"
		curl -L "https://github.com/docker/compose/releases/download/${compose_vr}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
	fi
}


while getopts "ihpv" argv; do
	case $argv in
		i)
			install=true
			;;
		p)
			have_proxy=true
			;;
		v)
			verbose=true
			;;
		h)
			usage
			exit
			;;
	esac
done

if [[ $EUID -ne 0 ]]; then
	echo "[docker] This script must be run as root"
	exit 1
fi


if [ $have_proxy = true ]; then
	set_proxy
fi

if [ $install = true]; then
	install_docker_repository
	install_docker
	if [ $have_proxy = true ]; then
		futherland_docker
	fi
else
	update_docker
fi

install_update_docker_compose

if [ $have_proxy = true ]; then
	unset_proxy
fi
