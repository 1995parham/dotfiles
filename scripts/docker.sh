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
	echo "install docker in iran🇮🇷"

	# shellcheck disable=1004,2016
	echo '
     _            _
  __| | ___   ___| | _____ _ __
 / _` |/ _ \ / __| |/ / _ \ |__|
| (_| | (_) | (__|   <  __/ |
 \__,_|\___/ \___|_|\_\___|_|
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

	mkdir -p ~/.docker/cli-plugins
	ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
}

main_pacman() {
	msg "install docker-compose / docker with pacman"
	sudo pacman -Syu --noconfirm --needed docker docker-compose

	msg "install hadolint/hadolint with yay"
	yay -Syu --needed --noconfirm hadolint-bin

	msg "install dive with yay"
	yay -Syu --needed --noconfirm dive-bin

	msg "install lazydocker with yay"
	yay -Syu --needed --noconfirm lazydocker-bin

	msg 'podman service with systemd'
	sudo systemctl enable --now docker.service

	msg "manage docker as a non-root user"
	sudo groupadd -f docker
	sudo usermod -aG docker "$USER"
	newgrp docker
}

main() {
	msg "$(docker version)"
	msg "$(hadolint --version)"
}
