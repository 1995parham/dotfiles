#!/bin/bash

usage() {
	echo "install podman instead of docker"

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

main_apt() {
	sudo apt install podman podman-docker containers-storage
}

main_brew() {
	msg 'install podman'
	brew install podman

	msg 'create and initialize podman machine'
	podman machine init || true
	podman machine start || true

	msg "podman and dive configuration"
	configfile containers registries.conf podman
}

main_pacman() {
	msg "install podman-compose / podman with pacman"
	require_pacman podman podman-docker podman-compose docker-compose slirp4netns podman-dnsname fuse-overlayfs netavark aardvark-dns

	require_aur hadolint-bin dive-bin lazydocker-bin

	msg "podman and dive configuration"
	configfile dive "" podman
	configfile containers "" podman

	msg "configure sub-gid and sub-uid"
	sudo touch /etc/subuid
	sudo touch /etc/subgid
	sudo usermod --add-subuids 200000-210000 --add-subgids 200000-210000 parham

	msg 'podman service with systemd-user'
	systemctl --user enable --now podman.service
	systemctl --user enable --now podman.socket

	msg 'archlinux uses cgroup v2 by default'
}

main() {
	msg "$(podman version)"
	msg "$(hadolint --version)"
}
