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
}

docker-repositories() {
	msg "installing tools for apt repository management"
	sudo apt-get -y update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

	msg "add new gpg key"
	proxy_start
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	proxy_stop

	read -p -r "[docker] do you want to activate docker apt proxy?[Y/n] " -n 1 accept
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
	read -p -r "[docker] do you want to install docker?[Y/n] " -n 1 install
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
	msg "there is nothing that we can do"

	return 1
}

main_pacman() {
	msg "install docker-compose / docker with pacman"
	sudo pacman -Syu --noconfirm --needed docker
	sudo pacman -Syu --needed --noconfirm docker-compose

	msg "install hadolint/hadolint with yay"
	yay -Syu --needed --noconfirm hadolint-bin
}

main() {
	msg "$(docker-compose version)"
	msg "$(docker version)"
	msg "$(hadolint --version)"

	msg "manage docker as a non-root user"
	sudo groupadd -f docker
	sudo usermod -aG docker "$USER"
	newgrp docker

	proxy_start
	# make sure about login
	docker login
	proxy_stop
}
