#!/usr/bin/env bash
usage() {
    echo "AMD GPU based on its open-source kernel module, for desktop environments"

    # shellcheck disable=1004,2016
    echo '
                                             _
  __ _ _ __  _   _        __ _ _ __ ___   __| |
 / _` | |_ \| | | |_____ / _` | |_ ` _ \ / _` |
| (_| | |_) | |_| |_____| (_| | | | | | | (_| |
 \__, | .__/ \__,_|      \__,_|_| |_| |_|\__,_|
 |___/|_|
  '
}

main_pacman() {
    require_pacman xf86-video-amdgpu
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
