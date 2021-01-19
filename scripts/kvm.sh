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
        sudo pacman -Syu --needed --noconfirm virt-manager x11-ssh-askpass

        message "kvm" "create base images folder"
        mkdir -p $HOME/kvm/base
        message "kvm" "create virtual machine disk folder"
        mkdir -p $HOME/kvm/vm
        message "kvm" "fetch ubuntu 20.04 LTS image"
        [ -f  $HOME/kvm/base/focal-server-cloudimg-amd64.img ] || wget -P $HOME/kvm/base https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

        message "kvm" "cloud-init is awesome for preconfigured vm"
        sudo pacman -Syu --needed --noconfirm cloud-image-utils
        [ -d $HOME/kvm/seed ] || cp -r $current_dir/kvm/seed $HOME/kvm

        message "kvm" "user access for kvm and libvirt"
        sudo usermod -aG libvirt $USER
        sudo usermod -aG kvm $USER
}
