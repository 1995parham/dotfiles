#!/usr/bin/env bash

usage() {
    echo "bitwarden command-line client (bw)"
    # shellcheck disable=1004,2016
    echo '
 _     _ _                         _
| |__ (_) |___      ____ _ _ __ __| | ___ _ __
| |_ \| | __\ \ /\ / / _` | |__/ _` |/ _ \ |_ \
| |_) | | |_ \ V  V / (_| | | | (_| |  __/ | | |
|_.__/|_|\__| \_/\_/ \__,_|_|  \__,_|\___|_| |_|
  '
}

main_brew() {
    require_brew bitwarden-cli
}

# Arch's own bitwarden-cli depends on nodejs-lts-jod, which conflicts with the
# current nodejs everything else here uses; the -bin package is Bitwarden's
# self-contained binary and needs no node at all.
main_pacman() {
    require_aur bitwarden-cli-bin
}

main_apt() {
    require_npm @bitwarden/cli
}

main() {
    if command -v bw &>/dev/null; then
        msg "bw $(bw --version 2>/dev/null) installed successfully" "success"
        msg "log in once with 'bw login', then 'export BW_SESSION=\$(bw unlock --raw)' per shell"
    fi

    return 0
}
