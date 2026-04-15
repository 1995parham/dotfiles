#!/usr/bin/env bash
usage() {
    echo "Open Broadcaster Software®"

    # shellcheck disable=1004,2016
    echo '
       _
  ___ | |__  ___
 / _ \| |_ \/ __|
| (_) | |_) \__ \
 \___/|_.__/|___/
  '
}

main_pacman() {
    require_pacman obs-studio
}

main_apt() {
    require_apt obs-studio
}

main_brew() {
    require_brew_cask obs@beta
}

main() {
    return 0
}
