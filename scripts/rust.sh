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
	echo '
                _
 _ __ _   _ ___| |_
| |__| | | / __| __|
| |  | |_| \__ \ |_
|_|   \__,_|___/\__|

  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm rustup
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	msg "install the stable toolchain as default"
	rustup toolchain install stable
	rustup default stable

	cargo install cargo-edit

	rustup component add clippy
	rustup component add rustfmt
	rustup component add rls rust-analysis rust-src
}
