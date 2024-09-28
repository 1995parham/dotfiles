#!/usr/bin/env bash
usage() {
    echo "VirtualBox is a general-purpose full virtualization software for x86_64 hardware (with version 7.1 additionally for macOS/Arm), targeted at laptop, desktop, server and embedded use."

    # shellcheck disable=1004,2016
    echo '
       _      _               _ _
__   _(_)_ __| |_ _   _  __ _| | |__   _____  __
\ \ / / | |__| __| | | |/ _` | | |_ \ / _ \ \/ /
 \ V /| | |  | |_| |_| | (_| | | |_) | (_) >  <
  \_/ |_|_|   \__|\__,_|\__,_|_|_.__/ \___/_/\_\
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
    require_brew_cask virtualbox
}

main() {
    return 0
}

main_parham() {
    return 0
}
