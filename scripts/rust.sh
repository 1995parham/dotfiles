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

# rustup owns the toolchain on every platform, so `rustup update` upgrades rust and a
# rust-toolchain.toml in a project selects its own version. the cargo plugins come from the
# system package where one exists, which saves a long compile on each machine.
#   cargo-edit:   `cargo upgrade` and `cargo set-version` (`cargo add` is a part of cargo now)
#   cargo-expand: shows the code a macro expands to

main_pacman() {
    require_pacman rustup cargo-edit cargo-expand
}

main_apt() {
    # rustup is a package since debian 13 and ubuntu 24.04
    require_apt rustup
}

main_brew() {
    require_brew rustup cargo-edit cargo-expand

    # the rustup of homebrew is keg-only: nothing of it is on PATH. rustup-init puts rustup and
    # its proxies (cargo, rustc) into ~/.cargo/bin, which zshenv already has on PATH.
    if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
        msg 'you know, osx always different'
        "$(brew --prefix rustup)/bin/rustup-init" --no-modify-path --default-toolchain none -y
    fi

    # shellcheck disable=1091
    source "$HOME/.cargo/env"
}

main() {
    msg "install the stable toolchain and select it as default"
    rustup toolchain install stable
    rustup default stable

    # the default profile already has clippy and rustfmt; they are named so that a minimal
    # profile gets them too.
    msg 'install rustup components'
    rustup component add clippy rustfmt rust-analyzer rust-src

    msg "$(rustc --version), $(cargo --version)"
}
