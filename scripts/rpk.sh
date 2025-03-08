#!/usr/bin/env bash

usage() {
    echo "The rpk command line interface tool is designed to manage your entire Redpanda cluster, without the need to run a separate script for each function, as with Apache Kafka."

    # shellcheck disable=1004,2016
    echo '
            _
 _ __ _ __ | | __
| |__| |_ \| |/ /
| |  | |_) |   <
|_|  | .__/|_|\_\
     |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur rpk-bin
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
    require_brew redpanda-data/tap/redpanda
}

main() {
    return 0
}

main_parham() {
    return 0
}
