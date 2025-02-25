#!/usr/bin/env bash
usage() {
    echo "Kubernetes for Prod, Tilt for Dev"

    # shellcheck disable=1004,2016
    echo '
 _   _ _ _
| |_(_) | |_
| __| | | __|
| |_| | | |_
 \__|_|_|\__|
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
    require_brew tilt
}

main() {
    return 0
}

main_parham() {
    return 0
}
