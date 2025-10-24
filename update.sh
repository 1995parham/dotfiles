#!/usr/bin/env bash

usage() {
    echo "update git submodule to its latest"

    # shellcheck disable=1004,2016
    echo '
                 _       _
 _   _ _ __   __| | __ _| |_ ___
| | | | |_ \ / _` |/ _` | __/ _ \
| |_| | |_) | (_| | (_| | ||  __/
 \__,_| .__/ \__,_|\__,_|\__\___|
      |_|
  '
}

main_pacman() {
    return 0
}

main_apt() {
    return 0
}

main_brew() {
    return 0
}

main_xbps() {
    return 0
}

main_pkg() {
    return 0
}

main() {
    git subtree pull --prefix scripts/lib https://github.com/1995parham/dotfiles.lib.git main --squash
}
