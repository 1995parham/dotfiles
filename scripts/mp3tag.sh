#!/usr/bin/env bash

usage() {
    echo "The universal tag editor and more ..."

    # shellcheck disable=1004,2016
    echo '
                _____ _
 _ __ ___  _ __|___ /| |_ __ _  __ _
| |_ ` _ \| |_ \ |_ \| __/ _` |/ _` |
| | | | | | |_) |__) | || (_| | (_| |
|_| |_| |_| .__/____/ \__\__,_|\__, |
          |_|                  |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur mp3tag
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask mp3tag
}

main() {
    return 0
}

main_parham() {
    return 0
}
