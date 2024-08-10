#!/usr/bin/env bash
usage() {
    echo "Transfer files over wifi from your computer to your mobile device by scanning a QR code without leaving the terminal"

    # shellcheck disable=1004,2016
    echo '

  __ _ _ __ ___ _ __
 / _` | |__/ __| |_ \
| (_| | | | (__| |_) |
 \__, |_|  \___| .__/
    |_|        |_|
  '
}

main_pacman() {
    require_aur qrcp
}

main_apt() {
    return 1
}

main_brew() {
    require_brew qrcp
}

main() {
    return 0
}
