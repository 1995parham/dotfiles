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
	require_brew_cask docker
	require_brew docker-compose lazydocker

	mkdir -p ~/.docker/cli-plugins
	ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
}

main_pacman() {
	require_pacman docker docker-compose dive docker-buildx docker-scan

	require_aur hadolint-bin lazydocker-bin

	root=${root:?"root must be set"}
	sudo mkdir /etc/docker || true
	sudo touch /etc/docker/daemon.json
	msg 'merge provided configuration with the one that is available on system'
	r=$(jq -s '.[0] * (.[1] // {})' "$root/docker/daemon.json" "/etc/docker/daemon.json")
	echo "$r" | sudo tee "/etc/docker/daemon.json"

	msg 'docker service with systemd'
	sudo systemctl enable --now docker.service

	msg "manage docker as a non-root user"
	sudo groupadd -f docker
	sudo usermod -aG docker "$USER"

	if yes_or_no "docker" "do you want to use v2ray as a docker proxy?"; then
		sudo mkdir -p /etc/systemd/system/docker.service.d/ || true
		echo '
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1080/"
Environment="HTTPS_PROXY=http://127.0.0.1:1080/"
    ' | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
		sudo systemctl daemon-reload
	fi

	sudo mkdir -p /etc/systemd/system/containerd.service.d/ || true
	echo '
[Service]
LimitNOFILE=1048576
    ' | sudo tee /etc/systemd/system/containerd.service.d/override.conf
	sudo systemctl daemon-reload

	# the following command create a new shell which is not
	# good to run in a script.
	# newgrp docker
}

main() {
	msg "$(docker version)"
	msg "$(hadolint --version)"
}
