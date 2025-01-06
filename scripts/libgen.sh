#!/usr/bin/env bash

usage() {
    echo "Library Genesis"

    # shellcheck disable=1004,2016
    echo '
 _ _ _
| (_) |__   __ _  ___ _ __
| | | |_ \ / _` |/ _ \ |_ \
| | | |_) | (_| |  __/ | | |
|_|_|_.__/ \__, |\___|_| |_|
           |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 0
}

main_xbps() {
    return 0
}

main_apt() {
    return 0
}

main_pkg() {
    return 0
}

main_brew() {
    return 0
}

main() {
    require_hosts_record 193.218.118.42 library.lol
    require_hosts_record 193.218.118.42 library.gift
    require_hosts_record 176.119.25.72 download.library.lol
    require_hosts_record 176.119.25.72 download.library.gift
}

main_parham() {
    return 0
}
