#!/usr/bin/env bash

usage() {
    echo -n -e "a glossy matrix collaboration client for the web, desktop and mobile"

    # shellcheck disable=1004,2016
    echo '
      _                           _
  ___| | ___ _ __ ___   ___ _ __ | |_
 / _ \ |/ _ \ |_ ` _ \ / _ \ |_ \| __|
|  __/ |  __/ | | | | |  __/ | | | |_
 \___|_|\___|_| |_| |_|\___|_| |_|\__|
  '
}

export additionals=("iamb")

main_pacman() {
    require_pacman element-desktop
}

main_brew() {
    require_brew_cask element
}

main_apt() {
    require_snap element-desktop
}
