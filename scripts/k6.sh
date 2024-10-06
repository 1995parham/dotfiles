#!/usr/bin/env bash
usage() {
    echo "Grafana k6 is an open-source, developer-friendly, and extensible load testing tool."

    # shellcheck disable=1004,2016
    printf '
 _     __
| | __/ /_
| |/ / |_ \
|   <| (_) |
|_|\_\\___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur k6
}

main_apt() {
    return 1
}

main_brew() {
    require_brew k6
}

main() {
    return 0
}

main_parham() {
    return 0
}
