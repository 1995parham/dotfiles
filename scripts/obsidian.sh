#!/usr/bin/env bash

usage() {
    echo "sharpen your thinking"

    # shellcheck disable=1004,2016
    echo '
       _         _     _ _
  ___ | |__  ___(_) __| (_) __ _ _ __
 / _ \| |_ \/ __| |/ _| | |/ _| | |_ \
| (_) | |_) \__ \ | (_| | | (_| | | | |
 \___/|_.__/|___/_|\__,_|_|\__,_|_| |_|

  '
}

main_pacman() {
    require_pacman obsidian
    # daftar-cli reads the same vault from a shell: https://github.com/parham-alvani/notes-linux
    require_aur daftar-cli-bin
}

main_brew() {
    require_brew_cask obsidian
    require_brew parham-alvani/tap/daftar-cli
}

main_apt() {
    require_snap obsidian --classic
}

main() {
    return 0
}

main_parham() {
    msg "hello parham, clone your private repositories"

    clone git@github.com:parham-alvani/notes "$HOME" "org"
}
