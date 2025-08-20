#!/usr/bin/env bash
usage() {
    echo "install, configure and daemonize coredns"

    # shellcheck disable=1004,2016
    echo '
                        _
  ___ ___  _ __ ___  __| |_ __  ___
 / __/ _ \| |__/ _ \/ _` | |_ \/ __|
| (_| (_) | | |  __/ (_| | | | \__ \
 \___\___/|_|  \___|\__,_|_| |_|___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur coredns
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    require_brew coredns

    mkdir -p "$(brew --prefix)/etc/coredns/"
    copycat "coredns" coredns/Corefile "$(brew --prefix)/etc/coredns/Corefile" false
}

main() {
    return 0
}

main_parham() {
    return 0
}
