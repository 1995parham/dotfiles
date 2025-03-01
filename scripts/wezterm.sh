#!/usr/bin/env bash

usage() {
    echo "WezTerm is a powerful cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust"

    # shellcheck disable=1004,2016
    echo '
                  _
__      _____ ___| |_ ___ _ __ _ __ ___
\ \ /\ / / _ \_  / __/ _ \ |__| |_ ` _ \
 \ V  V /  __// /| ||  __/ |  | | | | | |
  \_/\_/ \___/___|\__\___|_|  |_| |_| |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman wezterm wezterm-shell-integration wezterm-terminfo
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask wezterm@nightly
}

main() {
    configfile wezterm
}

main_parham() {
    return 0
}
