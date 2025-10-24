#!/usr/bin/env bash

usage() {
    echo "gopass for managing passwords"
    # shellcheck disable=1004,2016
    echo '
  __ _  ___  _ __   __ _ ___ ___
 / _` |/ _ \| |_ \ / _` / __/ __|
| (_| | (_) | |_) | (_| \__ \__ \
 \__, |\___/| .__/ \__,_|___/___/
 |___/      |_|
  '
}

export dependencies=("gpg")

main_apt() {
    gopass-upstall
}

main_brew() {
    require_brew gopass gopass-jsonapi
}

main_pacman() {
    require_pacman gopass gopass-jsonapi
}

gopass-upstall() {
    msg "installing gopass from github"

    require_github_release "gopasspw/gopass" "gopass" "gopass_\${version#v}_linux_amd64" "deb"

    msg "$(gopass version)"
}

main_parham() {
    msg "hello parham, clone your password repository"

    gopass clone --check-keys=false git@github.com:parham-alvani/passwords || true
}
