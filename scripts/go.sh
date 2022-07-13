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
	# yay -Syu goreleaser-bin
}

main() {
	msg "$(go version)"

	msg "create go directory structure"
	local gopath
	gopath=$HOME/.cache/go
	[ -d "$gopath/pkg" ] || mkdir -p "$gopath/pkg"

	local gobin
	gobin=$HOME/.local/bin
	[ -d "$gobin" ] || mkdir -p "$gobin"

	go env -w GOPATH="$HOME/.cache/go"
	go env -w GOBIN="$HOME/.local/bin"
	# right now goproxy.cn isn't stable
	# go env -w GOPROXY="https://goproxy.io,goproxy.cn,direct"
	go env -w GOPROXY="https://goproxy.io,direct"
	go env -w GONOSUMDB="gitlab.snapp.ir"
	go env -w GOPRIVATE="gitlab.snapp.ir"

	go-install-packages
}

go-install-packages() {
	msg "fetch some good and useful go packages"

	# Go Tools
	msg "go tools"

	go install github.com/yoheimuta/protolint/cmd/protolint@latest

	msg "install binary requirements of vim-go"

	hash nvim &>/dev/null && nvim +GoUpdateBinaries --headless +qall
	echo

	msg "golangci-lint $(golangci-lint --version)"
}
