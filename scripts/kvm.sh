#!/usr/bin/env bash

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
    require_pacman \
        qemu libvirt dnsmasq bridge-utils virt-manager \
        edk2-ovmf swtpm dmidecode \
        qemu-hw-display-virtio-gpu qemu-hw-display-virtio-gpu-pci \
        qemu-hw-display-virtio-gpu-gl qemu-hw-display-virtio-gpu-pci-gl \
        qemu-ui-spice-core qemu-ui-spice-app qemu-audio-spice \
        qemu-hw-display-virtio-vga qemu-hw-display-virtio-vga-gl \
        qemu-hw-usb-redirect qemu-hw-usb-host \
        terraform extra/cdrtools

    msg "user access for kvm and libvirt"
    sudo usermod -aG libvirt "$USER"
    sudo usermod -aG kvm "$USER"

    sudo systemctl enable --now libvirtd.service

    if [ "$(command -v firewall-cmd)" ]; then
        sudo firewall-cmd --reload
    fi
}

main() {
    msg "create base images folder"
    mkdir -p "$HOME/kvm/base"

    msg "create virtual machine disk folder"
    mkdir -p "$HOME/kvm/pool"
}

main_parham() {
    clone git@github.com:1995parham-me/kvm "$HOME/kvm" seed
}
