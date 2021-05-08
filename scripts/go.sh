#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : go.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
usage() {
	echo -n "setup working environment for go with neovim + fatih/vim-go"
	# shellcheck disable=1004
	echo '
  __ _  ___
 / _` |/ _ \
| (_| | (_) |
 \__, |\___/
 |___/
  '
}

main_brew() {
	brew install go
}

main_apt() {
	sudo apt install golang-go
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm go
}

main() {
	msg "$(go version)"

	msg "create go directory structure"
	local gopath
	gopath=$HOME/Documents/Go
	for dir in bin pkg src mod; do
		echo $dir
		[ -d "$gopath/$dir" ] || mkdir -p "$gopath/$dir"
	done

	go-install-packages
}

go-install-packages() {
	msg "fetch some good and useful go packages"

	# Go Tools
	msg "go tools"

	msg "install binary requirements of vim-go"

	hash nvim &>/dev/null && nvim +GoUpdateBinaries --headless +qall
	echo

	msg "golangci-lint $(golangci-lint --version)"
}
