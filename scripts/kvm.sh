#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : kvm.sh
#
# [] Creation Date : 15-01-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "kvm for manjaro"
	# shellcheck disable=1004
	echo '
 _
| | ____   ___ __ ___
| |/ /\ \ / / |_ ` _ \
|   <  \ V /| | | | | |
|_|\_\  \_/ |_| |_| |_|

  '
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm qemu
	sudo pacman -Syu --needed --noconfirm libvirt
	sudo pacman -Syu --needed --noconfirm dnsmasq bridge-utils
	sudo pacman -Syu --needed --noconfirm virt-manager
	# sudo pacman -Syu --needed --noconfirm ebtables

	msg "create base images folder"
	mkdir -p "$HOME/kvm/base"
	msg "create virtual machine disk folder"
	mkdir -p "$HOME/kvm/vm"
	msg "fetch ubuntu 20.04 LTS image"
	[ -f "$HOME/kvm/base/focal-server-cloudimg-amd64.img" ] || wget -P "$HOME/kvm/base" https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

	msg "cloud-init is awesome for preconfigured vm"
	sudo pacman -Syu --needed --noconfirm cloud-image-utils
	[ -d "$HOME/kvm/seed" ] || git clone git@github.com:1995parham-me/kvm "$HOME/kvm/seed"

	msg "user access for kvm and libvirt"
	sudo usermod -aG libvirt "$USER"
	sudo usermod -aG kvm "$USER"

	sudo systemctl enable libvirtd
}
