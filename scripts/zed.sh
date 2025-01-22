#!/usr/bin/env bash
usage() {
    echo "Zed is a next-generation code editor designed for high-performance collaboration with humans and AI."

    # shellcheck disable=1004,2016
    echo '
             _
 _______  __| |
|_  / _ \/ _` |
 / /  __/ (_| |
/___\___|\__,_|
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
    return 1
}

main() {
    return 0
}

main_parham() {
    return 0
}
