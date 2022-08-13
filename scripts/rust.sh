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
	require_pacman rustup
}

main_brew() {
	if [ ! -d "$HOME/.rustup" ]; then
		curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
	fi
	if [ ! -d "$HOME/.rustup" ] || [ ! -d "$HOME/.cargo" ]; then
		msg 'rustup installation failed'
		exit
	fi

	# shellcheck disable=1091,1090
	source "$HOME/.cargo/env"

	# enable rustup completions
	[ -d "$HOME/.zfunc" ] || mkdir "$HOME/.zfunc"
	rustup completions zsh >~/.zfunc/_rustup
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
