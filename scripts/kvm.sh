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
}
