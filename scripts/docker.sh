#!/bin/bash

usage() {
	echo "install docker, docker-compose, hadolint etc."

	# shellcheck disable=1004,2016
	echo '
     _            _
  __| | ___   ___| | _____ _ __
 / _` |/ _ \ / __| |/ / _ \ |__|
| (_| | (_) | (__|   <  __/ |
 \__,_|\___/ \___|_|\_\___|_|
  '
}

main_apt() {
	sudo apt-get -y update
	sudo apt-get -y install docker.io docker-compose
}

main_brew() {
	brew install --cask docker
	brew install docker-compose lazydocker

	mkdir -p ~/.docker/cli-plugins
	ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
}

main_pacman() {
	require_pacman docker docker-compose

	require_aur hadolint-bin dive-bin lazydocker-bin

	msg 'docker service with systemd'
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
