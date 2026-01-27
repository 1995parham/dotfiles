#!/usr/bin/env bash

usage() {
    echo "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers"

    # shellcheck disable=1004,2016
    echo '
                                  _
  __ _ _ __ _ __   ___ _   _ _ __| |
 / _` | |__| |_ \ / __| | | | |__| |
| (_| | |  | |_) | (__| |_| | |  | |
 \__, |_|  | .__/ \___|\__,_|_|  |_|
 |___/     |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur grpcurl-bin
}

main_apt() {
    return 1
}

main_brew() {
    require_brew grpcurl
}

main() {
    return 0
}

main_parham() {
    return 0
}
