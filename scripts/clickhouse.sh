#!/usr/bin/env bash

usage() {
    echo -n "ClickHouse client, the native CLI for ClickHouse servers"
    # shellcheck disable=2016
    echo '
      _ _      _    _
  ___| (_) ___| | _| |__   ___  _   _ ___  ___
 / __| | |/ __| |/ / |_ \ / _ \| | | / __|/ _ \
| (__| | | (__|   <| | | | (_) | |_| \__ \  __/
 \___|_|_|\___|_|\_\_| |_|\___/ \__,_|___/\___|
	'
}

# The cask and the AUR package both ship the single `clickhouse` binary,
# which runs the client as `clickhouse client` (or `clickhouse-client`).
main_brew() {
    require_brew_cask clickhouse
}

main_pacman() {
    require_aur clickhouse-client-bin
}

main() {
    if command -v clickhouse &>/dev/null; then
        msg "$(clickhouse client --version)"
    fi
}
