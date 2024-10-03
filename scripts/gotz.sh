#!/usr/bin/env bash

usage() {
    echo "timezone info in cli for working remotely"
    # shellcheck disable=2016
    echo '
             _
  __ _  ___ | |_ ____
 / _` |/ _ \| __|_  /
| (_| | (_) | |_ / /
 \__, |\___/ \__/___|
 |___/
  '
}

main_pacman() {
    require_aur gotz
}

main_brew() {
    require_brew 1995parham/tap/gotz
}

main() {
    configfile gotz
}
