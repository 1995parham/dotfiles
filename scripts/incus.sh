#!/usr/bin/env bash

usage() {
    echo "install Incus, a system container and virtual machine manager"

    # shellcheck disable=1004
    echo '
 _
(_)_ __   ___ _   _ ___
| | |_ \ / __| | | / __|
| | | | | (__| |_| \__ \
|_|_| |_|\___|\__,_|___/
  '
}

setup_incus_user() {
    msg "manage incus as a non-root user"
    sudo groupadd -f incus-admin
    sudo usermod -aG incus-admin "$USER"
}

initialize_incus() {
    if sudo incus info >/dev/null 2>&1 &&
        sudo incus storage list --format csv 2>/dev/null | grep -q .; then
        msg 'incus already initialized' 'notice'
        return 0
    fi

    if yes_or_no 'incus' 'initialize incus with default settings (--minimal)?'; then
        if ! sudo incus admin init --minimal; then
            msg 'failed to initialize incus' 'error'
            return 1
        fi
    else
        msg 'skipping incus init -- run "incus admin init" manually later' 'notice'
    fi
}

main_pacman() {
    require_pacman incus qemu-base

    if ! sudo systemctl enable --now incus.socket incus.service; then
        msg 'failed to enable incus service' 'error'
        return 1
    fi

    setup_incus_user
    initialize_incus || return 1
}

main_apt() {
    require_apt incus qemu-system

    if ! sudo systemctl enable --now incus.socket incus.service; then
        msg 'failed to enable incus service' 'error'
        return 1
    fi

    setup_incus_user
    initialize_incus || return 1
}

main_brew() {
    msg 'Incus does not run as a host on macOS -- installing the client only.' 'notice'
    require_brew incus
}

main() {
    if command -v incus >/dev/null; then
        msg "$(incus --version)"
    fi

    msg 're-login (or "newgrp incus-admin") to pick up group membership' 'notice'
    msg 'VM templates and Terraform live in the kvm repo -- this script only installs the daemon' 'info'
}
