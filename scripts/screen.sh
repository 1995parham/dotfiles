#!/usr/bin/env bash

usage() {
    echo -n -e "serial console here, now and beautiful"

    # shellcheck disable=1004,2016
    echo '

 ___  ___ _ __ ___  ___ _ __
/ __|/ __| |__/ _ \/ _ \ |_ \
\__ \ (__| | |  __/  __/ | | |
|___/\___|_|  \___|\___|_| |_|

  '
}

main_pacman() {
    require_pacman screen

    sudo usermod -aG uucp "$USER"
    newgrp uucp
}

main() {
    dotfile screen screenrc
}
