#!/usr/bin/env bash
usage() {
    echo "macOS Terminal Replacement"

    # shellcheck disable=1004,2016
    echo '
 _ _
(_) |_ ___ _ __ _ __ ___
| | __/ _ \ |__| |_ ` _ \
| | ||  __/ |  | | | | | |
|_|\__\___|_|  |_| |_| |_|
  '
}

root=${root:?"root must be set"}

main_brew() {
    require_brew_cask iterm2-nightly
}
