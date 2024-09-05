#!/usr/bin/env bash

usage() {
    echo -n "rust programming language install by rustup"
    echo '
                _
 _ __ _   _ ___| |_
| |__| | | / __| __|
| |  | |_| \__ \ |_
|_|   \__,_|___/\__|

  '
}

main_pacman() {
    require_pacman rustup
}

main_brew() {
    require_brew rustup

    msg 'you know, osx always different'
    rustup-init --no-modify-path -y
    # shellcheck disable=1091
    source "$HOME/.cargo/env"
}

main() {
    msg "install the stable toolchain and select it as default"
    rustup toolchain install stable
    rustup default stable

    msg 'install cargo plugins'
    cargo install cargo-edit cargo-expand

    msg 'install rustup plugins'
    rustup component add clippy
    rustup component add rustfmt
    rustup component add rls rust-analysis rust-src
}
