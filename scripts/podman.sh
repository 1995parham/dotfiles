#!/usr/bin/env bash
usage() {
    echo "The best free & open source container tools"

    # shellcheck disable=1004,2016
    echo '
                 _
 _ __   ___   __| |_ __ ___   __ _ _ __
| |_ \ / _ \ / _` | |_ ` _ \ / _` | |_ \
| |_) | (_) | (_| | | | | | | (_| | | | |
| .__/ \___/ \__,_|_| |_| |_|\__,_|_| |_|
|_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    msg 'According to RedHat, there is a dramatic performance benefit when using CRUN.'
    msg 'The C programming language implements the CRUN container runtime.'
    require_pacman crun

    require_pacman podman
    msg 'Podman depends on the netavark package as the default network backend for rootful containers (see podman-network(1)).'
    require_pacman netavark
    msg 'The optional dependency aardvark-dns is needed for name resolution among containers in the same network.'
    require_pacman aardvark-dns
    msg 'to replace Docker'
    require_pacman podman-compose podman-docker
}

main_apt() {
    require_apt crun podman podman-compose podman-docker
}

main_brew() {
    require_brew_cask podman-desktop
    msg 'install podman cli with docker-compose cli because they are used by podman'
    require_brew podman docker-compose

    podman machine init podman-machine-hvf
}

main() {
    return 0
}

main_parham() {
    return 0
}
