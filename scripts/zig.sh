#!/usr/bin/env bash

usage() {
    echo -n -e "Zig is a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."

    # shellcheck disable=1004,2016
    echo '
     _
 ___(_) __ _
|_  / |/ _` |
 / /| | (_| |
/___|_|\__, |
       |___/
  '
}

root=${root:?"root must be set"}

main_brew() {
    require_brew zig
}

main_pacman() {
    require_pacman zig
}

main_apt() {
    require_snap zig --classic --beta
}

main() {
    msg 'verify zig installation'
    zig version

    msg 'install zls (zig language server) via mason'
    require_mason zls
}
