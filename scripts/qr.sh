#!/usr/bin/env bash

usage() {
    echo -n "tools for encoding and decoding qr codes from the command line."
    # shellcheck disable=2016
    echo '
  __ _ _ __
 / _| | |__|
| (_| | |
 \__, |_|
    |_|
	'
}

main_brew() {
    require_brew zbar qrencode
}

main_pacman() {
    require_pacman zbar qrencode
}

main_apt() {
    require_apt zbar-tools qrencode
}

main() {
    return 0
}
