#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : docker.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

usage() {
	echo "install podman at snapp"

	# shellcheck disable=1004,2016
	echo '
                 _
 _ __   ___   __| |_ __ ___   __ _ _ __
| |_ \ / _ \ / _` | |_ ` _ \ / _` | |_ \
| |_) | (_) | (_| | | | | | | (_| | | | |
| .__/ \___/ \__,_|_| |_| |_|\__,_|_| |_|
|_|
  '
}

docker-repositories() {
	msg "installing tools for apt repository management"
	sudo apt-get -y update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

	msg "add new gpg key"
	proxy_start
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	proxy_stop

	read -r -p "[docker] do you want to activate docker apt proxy?[Y/n] " -n 1 accept
	echo

	if [[ $accept == "Y" ]]; then
		grep -i 'Acquire::http::Proxy::download.docker.com "http://127.0.0.1:1080";' /etc/apt/apt.conf.d/99proxy || echo 'Acquire::http::Proxy::download.docker.com "http://127.0.0.1:1080";' >>/etc/apt/apt.conf.d/99proxy
	fi

	msg "add docker apt repository"
	sudo add-apt-repository -y \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
}

main_apt() {
	read -r -p "[docker] do you want to install docker?[Y/n] " -n 1 install
	echo

	msg "installing docker"

	if [[ $install == "Y" ]]; then
		docker-repositories

		sudo apt-get -y update
		sudo apt-cache policy docker-ce
		sudo apt-get -y install docker-ce
	else
		sudo apt-get -y update
		sudo apt-get -y install docker-ce
	fi

}

main_brew() {
	brew install --cask docker
	brew install docker-compose lazydocker
}

main_pacman() {
	msg "install podman-compose / podman with pacman"
	sudo pacman -Syu --noconfirm --needed podman podman-docker podman-compose docker-compose slirp4netns podman-dnsname

	msg "install hadolint/hadolint with yay"
	yay -Syu --needed --noconfirm hadolint-bin

	msg "install dive with yay"
	yay -Syu --needed --noconfirm dive-bin

	msg "install lazydocker with yay"
	yay -Syu --needed --noconfirm lazydocker-bin

	msg "enable podman with snapp"
	configfile dive "" podman
	configfile containers "" podman

	msg "rootless podman"
	sudo touch /etc/subuid
	sudo touch /etc/subgid
	sudo usermod --add-subuids 200000-210000 --add-subgids 200000-210000 parham

	msg 'podman service with systemd-user'
	systemctl --user enable --now podman.service
	systemctl --user enable --now podman.socket

	msg 'remember arch has cgroup 2 by default'

	msg 'check /etc/hosts to contain the localhost'
	cat <<EOF
127.0.0.1 localhost
::1 localhost
EOF
}

main() {
	msg "$(docker version)"
	msg "$(hadolint --version)"
}
