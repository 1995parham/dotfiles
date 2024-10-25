#!/usr/bin/env bash

usage() {
    echo -n "Resource monitor that shows usage and stats for processor, memory, disks, network and processes."
    # shellcheck disable=2016
    echo '
 _     _
| |__ | |_ ___  _ __
| |_ \| __/ _ \| |_ \
| |_) | || (_) | |_) |
|_.__/ \__\___/| .__/
               |_|
	'
}

main_xbps() {
    require_xbps btop
}

main_brew() {
    require_brew btop
}

main_pacman() {
    require_pacman btop
}

main_apt() {
    require_apt btop
}

main() {
    configfile btop
}
