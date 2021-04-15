#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "rust programming language with rustup"
}

main() {
	if [ ! -d "$HOME/.rustup" ]; then
		curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
	fi

	# enable rustup completions
	[ -d "$HOME/.zfunc" ] || mkdir "$HOME/.zfunc"
	rustup completions zsh >~/.zfunc/_rustup

	# shellcheck disable=1090
	source "$HOME/.cargo/env"

	rustup component add clippy
	rustup component add rustfmt
	rustup component add rls rust-analysis rust-src
}
