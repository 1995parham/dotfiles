#!/usr/bin/env bash
usage() {
    echo "A free utility tool for MikroTik's RouterOS"

    # shellcheck disable=1004,2016
    echo '
          _       _
__      _(_)_ __ | |__   _____  __
\ \ /\ / / | |_ \| |_ \ / _ \ \/ /
 \ V  V /| | | | | |_) | (_) >  <
  \_/\_/ |_|_| |_|_.__/ \___/_/\_\
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
    require_brew_cask winbox
}

main() {
    return 0
}

main_parham() {
    return 0
}
