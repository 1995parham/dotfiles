#!/usr/bin/env bash
usage() {
    echo "Wave Terminal is a modern terminal that includes graphical capabilities like web browsing, file previews, and AI assistance alongside traditional terminal features."

    # shellcheck disable=1004,2016
    echo '

__      ____ ___   _____
\ \ /\ / / _` \ \ / / _ \
 \ V  V / (_| |\ V /  __/
  \_/\_/ \__,_| \_/ \___|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
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
    require_brew_cask wave
}

main() {
    return 0
}

main_parham() {
    return 0
}
