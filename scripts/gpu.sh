#!/usr/bin/env bash
usage() {
    echo "Tools required for having fun with your GPU without knowing its brand"

    # shellcheck disable=1004,2016
    echo '

  __ _ _ __  _   _
 / _` | |_ \| | | |
| (_| | |_) | |_| |
 \__, | .__/ \__,_|
 |___/|_|
  '
}

main_pacman() {
    require_pacman libva-utils vdpauinfo nvtop
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
