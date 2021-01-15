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
	echo "usage: docker"
}

docker-repositories() {
	message "docker" "Installing tools for apt repository management"
	sudo apt-get -y update
	sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

	message "docker" "Add new GPG key"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	message "docker" "Add docker apt repository"
	sudo add-apt-repository -y \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
}

docker-install() {
	message "docker" "Installing docker"

	if [[ "$(command -v apt)" ]]; then
		sudo apt-get -y update
		sudo apt-cache policy docker-ce
		sudo apt-get -y install docker-ce
	elif [[ "$(command -v pacman)" ]]; then
		sudo pacman -Syu --noconfirm --needed docker
	fi

	message "docker" "Manage Docker as a non-root user"
	sudo groupadd -f docker
	sudo usermod -aG docker $USER
}

docker-update() {
	message "docker" "Updating docker"

	if [[ "$(command -v apt)" ]]; then
		sudo apt-get -y update
		sudo apt-get -y install docker-ce
	elif [[ "$(command -v pacman)" ]]; then
		sudo pacman -Syu --noconfirm --needed docker
	fi
}

docker-compose-install() {
	if [[ "$(command -v apt)" ]]; then
		echo "There is nothing that we can do"
	elif [[ "$(command -v pacman)" ]]; then
		message "docker" "Install docker-compose with pacman"
		sudo pacman -Syu --needed --noconfirm docker-compose
	fi

	message "docker" "$(docker-compose version)"
}

docker-hadolint-install() {
	if [[ "$(command -v apt)" ]]; then
		echo "There is nothing that we can do"
	elif [[ "$(command -v pacman)" ]]; then
		message "docker" "Install hadolint/hadolint with yay"
		yay -Syu --needed --noconfirm hadolint-bin
	fi

	message "docker" "$(hadolint --version)"
}

main() {
	read -p "[docker] do you want to install docker ?[Y/n] " -n 1 install; echo

	if [[ $install == "Y" ]]; then
		if [[ "$(command -v apt)" ]]; then
			docker-repositories
		fi
		docker-install
	else
		docker-update
	fi

	docker-compose-install
	docker-hadolint-install

        # make sure about login
        docker login
}
