#!/usr/bin/env bash
usage() {
    echo "Simple and flexible tool for managing secrets"

    # shellcheck disable=1004,2016
    echo '

 ___  ___  _ __  ___
/ __|/ _ \| |_ \/ __|
\__ \ (_) | |_) \__ \
|___/\___/| .__/|___/
          |_|
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
    require_brew sops
}

main() {
    return 0
}

main_parham() {
    return 0
}
