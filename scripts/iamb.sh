#!/usr/bin/env bash

usage() {
    echo -n -e "a matrix client for vim addicts"

    # shellcheck disable=1004,2016
    echo '
 _                 _
(_) __ _ _ __ ___ | |__
| |/ _` | |_ ` _ \| |_ \
| | (_| | | | | | | |_) |
|_|\__,_|_| |_| |_|_.__/
  '
}

main_pacman() {
    require_aur iamb
}

main_brew() {
    require_brew iamb
}

main() {
    configfile "iamb"
}
