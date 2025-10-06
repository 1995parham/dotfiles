#!/usr/bin/env bash

usage() {
    echo -n "swift programming language install by swiftly"
    printf '
               _  __ _
 _____      __(_)/ _| |_
/ __\ \ /\ / /| | |_| __|
\__ \\ V  V / | |  _| |_
|___/ \_/\_/  |_|_|  \__|

  '
}

main_brew() {
    require_brew swiftly

    msg 'initializing swiftly'
    swiftly init --quiet-shell-followup -y
    # shellcheck disable=SC1090,SC1091
    source "${HOME}/.swiftly/env.sh"
}

main() {
    msg "install the latest stable toolchain"
    swiftly install latest

    msg "verify swift installation"
    swift --version

    msg 'install sourcekit-lsp for language server support'
    require_mason sourcekit-lsp
}
