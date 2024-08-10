#!/usr/bin/env bash
usage() {
    echo "The free app that makes your Internet safer (even when you are using speedify)"

    # shellcheck disable=1004,2016
    echo '

__      ____ _ _ __ _ __
\ \ /\ / / _` | |__| |_ \
 \ V  V / (_| | |  | |_) |
  \_/\_/ \__,_|_|  | .__/
                   |_|
  '
}

main_brew() {
    require_brew_cask cloudflare-warp
}

main_pacman() {
    require_aur cloudflare-warp-bin

    sudo systemctl enable --now warp-svc.service
    warp-cli register
    warp-cli status
}

main() {
    return 0
}

main_parham() {
    return 0
}
