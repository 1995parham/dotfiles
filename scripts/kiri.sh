#!/usr/bin/env bash

usage() {
    echo "Kiri - a small container runtime behind the Docker CLI: https://runkiri.com"

    # shellcheck disable=1004,2016
    echo '
 _    _      _
| | _(_)_ __(_)
| |/ / | |__| |
|   <| | |  | |
|_|\_\_|_|  |_|
  '
}

# kiri is not in the main list of homebrew yet, the cask comes from the tap of its author.
kiri_tap='libracoder/kiri'

main_brew() {
    # HOMEBREW_REQUIRE_TAP_TRUST=1 (set in our shell env) refuses a tap that is not trusted.
    # the trust is here and not in brew.sh, so only a machine that asks for kiri trusts the tap.
    if ! brew trust --tap "${kiri_tap}" >/dev/null 2>&1; then
        msg "failed to trust tap ${kiri_tap}" 'error'
        return 1
    fi

    require_brew_cask "${kiri_tap}/kiri"
}

main() {
    # the first launch of Kiri.app runs `kiri setup`: it adds PATH lines and the `kiri` docker
    # context, and it takes /var/run/docker.sock. this script does not start it, so docker
    # desktop or colima keeps the socket until the person opens the app.
    msg 'open Kiri.app to complete the setup, it adds the kiri docker context' 'notice'
    msg 'select the runtime with: docker context use kiri (or desktop-linux, colima)' 'notice'
    msg 'bring images, volumes and containers from docker desktop with: kiri import' 'notice'

    if command -v kiri &>/dev/null; then
        msg "$(kiri --version 2>/dev/null || echo 'kiri installed')"
    fi
}
