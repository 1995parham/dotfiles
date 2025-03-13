#!/usr/bin/env bash

usage() {
    echo "Manage Secrets & Protect Sensitive Data"

    # shellcheck disable=1004,2016
    echo '
                  _ _
__   ____ _ _   _| | |_
\ \ / / _` | | | | | __|
 \ V / (_| | |_| | | |_
  \_/ \__,_|\__,_|_|\__|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
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
    require_brew hashicorp/tap/vault
}

main() {
    return 0
}

main_parham() {
    return 0
}
