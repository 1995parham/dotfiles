#!/usr/bin/env bash
usage() {
    echo "DBeaver Community is a free cross-platform database tool for developers, database administrators, analysts, and everyone working with data."

    # shellcheck disable=1004,2016
    echo '
     _ _
  __| | |__   ___  __ ___   _____ _ __
 / _` | |_ \ / _ \/ _` \ \ / / _ \ |__|
| (_| | |_) |  __/ (_| |\ V /  __/ |
 \__,_|_.__/ \___|\__,_| \_/ \___|_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman dbeaver
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask dbeaver-community
}

main() {
    return 0
}

main_parham() {
    return 0
}
