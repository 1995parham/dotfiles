#!/usr/bin/env bash

usage() {
    echo "your vault, natively: https://github.com/parham-alvani/notes-linux"

    # shellcheck disable=1004,2016
    echo '
     _        __ _
  __| | __ _ / _| |_ __ _ _ __
 / _| |/ _| | |_| __/ _| | |__|
| (_| | (_| |  _| || (_| | |
 \__,_|\__,_|_|  \__\__,_|_|

  '
}

# a desktop session runs now or the machine boots into one; a server gets daftar-cli alone.
has_desktop() {
    [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]] && return 0
    [[ "$(systemctl get-default 2>/dev/null)" == "graphical.target" ]]
}

main_pacman() {
    if has_desktop; then
        # the app, with daftar-cli in it
        require_aur daftar-bin
    else
        msg "no desktop, so daftar-cli alone"
        require_aur daftar-cli-bin
    fi
}

main_brew() {
    if [[ "$(uname)" == "Darwin" ]]; then
        require_brew_cask parham-alvani/tap/daftar
    fi
    require_brew parham-alvani/tap/daftar-cli
}

main() {
    return 0
}

main_parham() {
    msg "hello parham, clone your private repositories"

    clone git@github.com:parham-alvani/notes "$HOME" "org"
}
