#!/usr/bin/env bash

usage() {
    echo "below is an interactive tool to view and record historical system data."

    # shellcheck disable=1004,2016
    echo '
 _          _
| |__   ___| | _____      __
| |_ \ / _ \ |/ _ \ \ /\ / /
| |_) |  __/ | (_) \ V  V /
|_.__/ \___|_|\___/ \_/\_/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur below
}

main_xbps() {
    return 1
}

main_apt() {
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
