#!/usr/bin/env bash
usage() {
    echo "RaspberryPI is like koochooloo"

    # shellcheck disable=1004,2016
    echo '
            _
 _ __ _ __ (_)
| |__| |_ \| |
| |  | |_) | |
|_|  | .__/|_|
     |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask raspberry-pi-imager
}

main() {
    return 0
}

main_parham() {
    return 0
}
