#!/usr/bin/env bash

usage() {
    echo "navi cheatsheet"
    echo '
                   _
 _ __   __ ___   _(_)
| |_ \ / _` \ \ / / |
| | | | (_| |\ V /| |
|_| |_|\__,_| \_/ |_|
  '
}

main_brew() {
    require_brew navi
}

main_apt() {
    if [ ! -f /usr/local/bin/navi ]; then
        sudo BIN_DIR=/usr/local/bin bash -c "$(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)"
    fi
}

main_pacman() {
    require_pacman navi
}

main() {
    configfile navi
}

main_parham() {
    user=1995parham
    repo=cheats
    clone "git@github.com:${user}/${repo}" "$(navi info cheats-path)" "${user}__${repo}"
}

main_elahe() {
    main_parham
}

main_raha() {
    main_parham
}
