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

main_elaheh() {
    msg "hello elaheh, clone the shared password repository"

    # same store as parham: elaheh's key is one of the three recipients in
    # its .gpg-id, so there is no separate repository to clone.
    gopass clone --check-keys=false git@github.com:parham-alvani/passwords || true

    # gopass seeds the store's git identity from $USER and leaves the email
    # empty, so it then refuses its own commits with "Git Email not set".
    # core.autosync and core.autopush are on, so every saved secret commits
    # and pushes through this identity -- it has to be right.
    store="${HOME}/.local/share/gopass/stores/root"
    if [[ -d "${store}/.git" ]]; then
        git -C "${store}" config user.name "Elaheh Dastan"
        git -C "${store}" config user.email "elahe.dstn@gmail.com"
    fi
}
