#!/usr/bin/env bash

usage() {
    echo "The Samsung Galaxy Buds are a line of wireless Bluetooth earbuds designed by Samsung Electronics. They were first released on March 9, 2019, as the successor to the Gear IconX."

    # shellcheck disable=1004,2016,2028
    echo '
             _                  _               _
  __ _  __ _| | __ ___  ___   _| |__  _   _  __| |___
 / _` |/ _` | |/ _` \ \/ / | | | |_ \| | | |/ _` / __|
| (_| | (_| | | (_| |>  <| |_| | |_) | |_| | (_| \__ \
 \__, |\__,_|_|\__,_/_/\_\\__, |_.__/ \__,_|\__,_|___/
 |___/                    |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur galaxybudsclient-bin
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask galaxybudsclient
}

main() {
    return 0
}

main_parham() {
    return 0
}
