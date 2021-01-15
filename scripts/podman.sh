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
        sudo pacman -Syu --noconfirm --needed podman
        configfile "containers" "" "podman"
}
