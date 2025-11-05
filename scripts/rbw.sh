#!/usr/bin/env bash
usage() {
    echo "Unofficial Bitwarden CLI in Rust"

    # shellcheck disable=1004,2016
    echo '
      _
 _ __| |____      __
| |__| |_ \ \ /\ / /
| |  | |_) \ V  V /
|_|  |_.__/ \_/\_/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman rbw
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    require_brew rbw

    copycat rbw rbw/arvan.json "$HOME/Library/Application Support/rbw-arvan/config.json" "false"
}

main() {
    return 0
}

main_parham() {
    return 0
}
