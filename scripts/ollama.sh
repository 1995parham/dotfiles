#!/usr/bin/env bash
usage() {
    echo "Get up and running with large language models."

    # shellcheck disable=1004,2016
    echo '
       _ _
  ___ | | | __ _ _ __ ___   __ _
 / _ \| | |/ _` | |_ ` _ \ / _` |
| (_) | | | (_| | | | | | | (_| |
 \___/|_|_|\__,_|_| |_| |_|\__,_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman ollama

    sudo systemctl enable --now ollama.service
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
    return 1
}

main() {
    return 0
}

main_parham() {
    return 0
}
