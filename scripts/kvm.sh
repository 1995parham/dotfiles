#!/bin/bash

usage() {
	echo "kvm on arch not ubuntu"
	# shellcheck disable=1004
	echo '
 _
| | ____   ___ __ ___
| |/ /\ \ / / |_ ` _ \
|   <  \ V /| | | | | |
|_|\_\  \_/ |_| |_| |_|
  '
}

main_pacman() {
	require_pacman qemu
	require_pacman libvirt
	require_pacman dnsmasq bridge-utils
	require_pacman virt-manager
	# require_pacman ebtables

	msg "create base images folder"
	mkdir -p "$HOME/kvm/base"

	msg "create virtual machine disk folder"
	mkdir -p "$HOME/kvm/pool"

	msg "cloud-init is awesome for preconfigured vm"
	require_pacman cloud-image-utils
	[ -d "$HOME/kvm/seed" ] || git clone git@github.com:1995parham-me/kvm "$HOME/kvm/seed"

	msg "user access for kvm and libvirt"
	sudo usermod -aG libvirt "$USER"
	sudo usermod -aG kvm "$USER"

	sudo systemctl enable --now libvirtd.service
}
