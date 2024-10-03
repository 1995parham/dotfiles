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

root=${root:?"root must be set"}

main_pacman() {
    require_aur gotz

    configfile gotz
}

main_brew() {
    require_brew 1995parham/tap/gotz

    path="$HOME/Library/Application Support"
    linker "gotz" "$root/gotz" "$path/gotz"
}

main() {
    return 0
}
