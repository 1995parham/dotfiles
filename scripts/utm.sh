#!/usr/bin/env bash

usage() {
    echo "Securely run operating systems on your Mac"

    # shellcheck disable=1004,2016
    echo '
       _
 _   _| |_ _ __ ___
| | | | __| |_ ` _ \
| |_| | |_| | | | | |
 \__,_|\__|_| |_| |_|
  '
}

main_brew() {
    require_brew_cask utm
}

main() {
    return 0
}
