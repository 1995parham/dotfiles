#!/usr/bin/env bash
usage() {
    echo "kind is a tool for running local Kubernetes clusters using Docker container nodes"

    # shellcheck disable=1004,2016
    echo '
 _    _           _
| | _(_)_ __   __| |
| |/ / | |_ \ / _` |
|   <| | | | | (_| |
|_|\_\_|_| |_|\__,_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur kind
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
    return 1
}

main() {
    return 0
}

main_parham() {
    return 0
}
