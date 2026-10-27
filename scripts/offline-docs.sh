#!/usr/bin/env bash
usage() {
    echo "offline references: kiwix (wikipedia, stack exchange, devdocs), the arch wiki and tldr pages"

    # shellcheck disable=1004,2016
    echo '
        __  __ _ _                      _
  ___  / _|/ _| (_)_ __   ___        __| | ___   ___ ___
 / _ \| |_| |_| | | |_ \ / _ \_____ / _` |/ _ \ / __/ __|
| (_) |  _|  _| | | | | |  __/_____| (_| | (_) | (__\__ \
 \___/|_| |_| |_|_|_| |_|\___|      \__,_|\___/ \___|___/
  '
}

root=${root:?"root must be set"}

main_pacman() {
    # kiwix reads .zim archives (wikipedia, stack exchange, devdocs), offline;
    # arch-wiki-docs is the whole arch wiki as html (arch-wiki-lite searches
    # it: wiki-search), tealdeer is tldr with a local page cache
    require_pacman kiwix-desktop kiwix-tools arch-wiki-docs arch-wiki-lite tealdeer
}

main_xbps() {
    return 1
}

main_apt() {
    require_apt kiwix kiwix-tools tealdeer
}

main_pkg() {
    return 1
}

main_brew() {
    require_brew_cask kiwix
    require_brew tealdeer
}

main() {
    configfile tealdeer "config.toml" offline-docs
    tldr --update || msg "tldr pages are fetched from github, retry through a tunnel" "warn"

    # kiwix-serve over every downloaded archive, on http://127.0.0.1:8090
    configsystemd offline-docs kiwix-serve.service
    systemctl --user daemon-reload

    msg "download archives with: kiwix-fetch [names...] (list in offline-docs/zims.txt); it starts kiwix-serve on http://127.0.0.1:8090"
}
