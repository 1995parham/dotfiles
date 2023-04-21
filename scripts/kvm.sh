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
	require_pacman qemu libvirt dnsmasq bridge-utils virt-manager vagrant edk2-ovmf swtpm
	# require_pacman ebtables

	msg "user access for kvm and libvirt"
	sudo usermod -aG libvirt "$USER"
	sudo usermod -aG kvm "$USER"

	sudo systemctl enable --now libvirtd.service

	if ! vagrant plugin list | grep vagrant-libvirt; then
		proxy_start && vagrant plugin install vagrant-libvirt && proxy_stop
	fi
}

main() {
	msg "create base images folder"
	mkdir -p "$HOME/kvm/base"

	msg "create virtual machine disk folder"
	mkdir -p "$HOME/kvm/pool"
}

main_parham() {
	msg "vagrant is awesome for preconfigured vm"

	cd "$HOME/kvm" || return
	clone 1995parham-me/kvm git@github.com: seed
	cd - || return
}
