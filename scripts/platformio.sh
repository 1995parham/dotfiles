#!/usr/bin/env bash

usage() {
    echo -n -e "platformio, professional collaborative platform for embedded development"

    # shellcheck disable=1004,2016
    echo '
       _       _    __                      _
 _ __ | | __ _| |_ / _| ___  _ __ _ __ ___ (_) ___
| |_ \| |/ _| | __| |_ / _ \| |__| |_ |_ \| |/ _ \
| |_) | | (_| | |_|  _| (_) | |  | | | | | | | (_) |
| |__/|_|\____|\__|_|  \___/|_|  |_| |_| |_|_|\___/
|_|
  '
}

main_pacman() {
    yay -Syu --needed --noconfirm platformio
}

main() {
    return 0
}
