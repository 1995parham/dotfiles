#!/usr/bin/env bash

usage() {
    echo "age, simple file encryption; rahacloud share encrypts every secret with it"
    # shellcheck disable=1004,2016
    echo '
  __ _  __ _  ___
 / _` |/ _` |/ _ \
| (_| | (_| |  __/
 \__,_|\__, |\___|
       |___/
  '
}

main_pacman() {
    require_pacman age
}

main_apt() {
    require_apt age
}

main_brew() {
    require_brew age
}

main() {
    if command -v age &>/dev/null; then
        msg "age $(age --version 2>/dev/null) installed successfully" "success"
    fi

    return 0
}
