#!/usr/bin/env bash
usage() {
    echo "Secure and Reliable Free Private Messaging and Calling"

    # shellcheck disable=1004,2016
    echo '
          _           _
__      _| |__   __ _| |_ ___  __ _ _ __  _ __
\ \ /\ / / |_ \ / _` | __/ __|/ _` | |_ \| |_ \
 \ V  V /| | | | (_| | |_\__ \ (_| | |_) | |_) |
  \_/\_/ |_| |_|\__,_|\__|___/\__,_| .__/| .__/
                                   |_|   |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    msg 'please login using chrome browser and have fun' 'error'
}

main_apt() {
    msg 'please login using chrome browser and have fun' 'error'
}

main_brew() {
    require_brew_cask whatsapp@beta
}

main() {
    return 0
}

main_parham() {
    return 0
}
