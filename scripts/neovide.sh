#!/usr/bin/env bash

usage() {
    echo "No Nonsense Neovim Client in Rust"

    # shellcheck disable=1004,2016
    echo '
                       _     _
 _ __   ___  _____   _(_) __| | ___
| |_ \ / _ \/ _ \ \ / / |/ _` |/ _ \
| | | |  __/ (_) \ V /| | (_| |  __/
|_| |_|\___|\___/ \_/ |_|\__,_|\___|
  '
}

export dependencies=("neovim")

pre_main() {
    return 0
}

main_pacman() {
    require_pacman neovide
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask neovide
}

main() {
    configfile neovide
}

main_parham() {
    return 0
}
