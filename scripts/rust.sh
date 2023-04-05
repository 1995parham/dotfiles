#!/bin/bash

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
	require_pacman rust
}

main_brew() {
	require_brew rust
}

main() {
	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	msg "install the stable toolchain and select it as default"
	# rustup toolchain install stable
	# rustup default stable

	mkdir -p "$HOME/.cargo" || true
	cp "$dotfiles_root/rust/config.toml" "$HOME/.cargo/config.toml"

	msg 'install cargo plugins'
	cargo install cargo-edit cargo-expand

	msg 'install rustup plugins'
	# rustup component add clippy
	# rustup component add rustfmt
	# rustup component add rls rust-analysis rust-src
}
