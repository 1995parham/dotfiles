#!/usr/bin/env bash

usage() {
    echo "Cloudflare CLIs: wrangler (Workers/Pages/R2/D1/KV) and flarectl (DNS/zones)"
    # shellcheck disable=2016
    echo '
       _                 _  __ _
   ___| | ___  _   _  __| |/ _| | __ _ _ __ ___
  / __| |/ _ \| | | |/ _` | |_| |/ _` | `__/ _ \
 | (__| | (_) | |_| | (_| |  _| | (_| | | |  __/
  \___|_|\___/ \__,_|\__,_|_| |_|\__,_|_|  \___|
    '
}

export dependencies=("node" "go")

main_brew() {
    require_npm wrangler
}

main_pacman() {
    require_aur wrangler-bin
}

main_apt() {
    require_npm wrangler
}

main_pkg() {
    require_npm wrangler
}

main() {
    require_go github.com/cloudflare/cloudflare-go/cmd/flarectl@latest

    if command -v wrangler &>/dev/null; then
        msg "wrangler $(wrangler --version 2>/dev/null | tail -1) installed" "success"
    fi

    if command -v flarectl &>/dev/null; then
        msg "flarectl installed" "success"
    fi

    return 0
}
