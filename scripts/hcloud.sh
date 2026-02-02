#!/usr/bin/env bash

usage() {
    echo "
        _         _                 _
       | |__   __| | ___  _   _  __| |
       | '_ \ / _\`|/ _ \| | | |/ _\`|
       | | | | (_| | (_) | |_| | (_| |
       |_| |_|\__,_|\___/ \__,_|\__,_|

       hcloud is a command-line interface for Hetzner Cloud
    "
}

main_brew() {
    require_brew hcloud
}

main_pacman() {
    require_pacman hcloud
}

main_apt() {
    require_apt hcloud-cli
}

main() {
    if command -v hcloud &>/dev/null; then
        msg "hcloud $(hcloud version 2>/dev/null | head -1) installed successfully" "success"
    fi

    return 0
}
