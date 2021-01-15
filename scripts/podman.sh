#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : podman.sh
#
# [] Creation Date : 15-01-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: podman"
}

main() {
        sudo pacman -Syu --noconfirm --needed podman podman-compose
        configfile "containers" "" "podman"

        # https://www.redhat.com/sysadmin/rootless-podman
        sudo touch /etc/subuid
        sudo touch /etc/subgid
        grep -i $USER /etc/subuid || echo "$USER:100000:65536" | sudo tee -a /etc/subuid
        grep -i $USER /etc/subgid || echo "$USER:100000:65536" | sudo tee -a /etc/subgid

        # make sure about login
        podman login

        message "podman" "podman-compose requires gcr images so run it for the first time with proxy"
        message "podman" "also it would be great to check docker-compose file for mounting"
}
