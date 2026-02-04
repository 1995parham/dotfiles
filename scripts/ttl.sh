#!/usr/bin/env bash

usage() {
    echo "ttl - a terminal based typing test"
    # shellcheck disable=2016
    echo '
 _   _   _
| |_| |_| |
| __| __| |
| |_| |_| |
 \__|\__|_|
    '
}

main_brew() {
    local arch
    arch=$(uname -m)

    if [[ "${arch}" == "arm64" ]]; then
        require_github_release "lance0/ttl" "ttl" "ttl-aarch64-apple-darwin" "tar.gz"
    else
        require_github_release "lance0/ttl" "ttl" "ttl-x86_64-apple-darwin" "tar.gz"
    fi
}

main_apt() {
    require_github_release "lance0/ttl" "ttl" "ttl-x86_64-unknown-linux-musl" "tar.gz"
}

main_pacman() {
    require_github_release "lance0/ttl" "ttl" "ttl-x86_64-unknown-linux-musl" "tar.gz"
}

main_xbps() {
    require_github_release "lance0/ttl" "ttl" "ttl-x86_64-unknown-linux-musl" "tar.gz"
}

main_pkg() {
    require_github_release "lance0/ttl" "ttl" "ttl-aarch64-unknown-linux-gnu" "tar.gz"
}
