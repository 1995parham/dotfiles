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
        echo "usage: kvm"
}

main() {
        sudo pacman -Syu --needed --noconfirm qemu
        sudo pacman -Syu --needed --noconfirm libvirt
        sudo pacman -Syu --needed --noconfirm ebtables dnsmasq bridge-utils
        sudo pacman -Syu --needed --noconfirm virt-manager

        message "kvm" "create base images folder"
        mkdir -p $HOME/kvm/base
        message "kvm" "create virtual machine disk folder"
        mkdir -p $HOME/kvm/vm
        # fetch ubuntu 20.04 LTS image
        wget -P $HOME/kvm/base https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

        sudo pacman -Syu --needed --noconfirm cloud-image-utils
}
