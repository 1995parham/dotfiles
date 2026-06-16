#!/usr/bin/env bash

usage() {
    echo "lego: Let's Encrypt / ACME client (supports DNS-01, HTTP-01, TLS-ALPN-01)"
    # shellcheck disable=1004,2016
    echo '
  _
 | | ___  __ _  ___
 | |/ _ \/ _` |/ _ \
 | |  __/ (_| | (_) |
 |_|\___|\__, |\___/
         |___/
  '
}

lego-upstall() {
    msg "installing lego from github releases"

    require_github_release "go-acme/lego" "lego" "lego_\${version}_linux_amd64" "tar.gz"

    msg "$(lego --version 2>/dev/null | head -1)"
}

main_pacman() {
    require_aur lego-bin
}

main_brew() {
    require_brew lego
}

main_apt() {
    lego-upstall
}

main_pkg() {
    lego-upstall
}

main() {
    if command -v lego &>/dev/null; then
        msg "$(lego --version 2>/dev/null | head -1) installed" "success"
    fi

    return 0
}
