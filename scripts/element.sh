#!/usr/bin/env bash
usage() {
    echo "Element is a free and open-source software instant messaging client implementing the Matrix protocol."

    # shellcheck disable=1004,2016
    echo '
      _                           _
  ___| | ___ _ __ ___   ___ _ __ | |_
 / _ \ |/ _ \ |_ ` _ \ / _ \ |_ \| __|
|  __/ |  __/ | | | | |  __/ | | | |_
 \___|_|\___|_| |_| |_|\___|_| |_|\__|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman element-desktop
}

main_brew() {
    require_brew_cask element
}

main() {
    return 0
}

main_parham() {
    return 0
}
