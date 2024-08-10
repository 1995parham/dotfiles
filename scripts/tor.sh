#!/usr/bin/env bash
usage() {
    echo "Right now, Tor is protecting the privacy of millions of people like you!"

    # shellcheck disable=1004,2016
    echo '
 _
| |_ ___  _ __
| __/ _ \| |__|
| || (_) | |
 \__\___/|_|
  '
}

main_pacman() {
    require_pacman torbrowser-launcher
}

main_brew() {
    require_brew_cask tor-browser
}

main() {
    return 0
}

main_parham() {
    return 0
}
