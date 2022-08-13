#!/bin/bash

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
	require_pacman go
}

main() {
	msg "$(go version)"

	msg "create go directories structure"
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

	go env

	go-install-packages
}

go-install-package() {
	local pkg=$1
	msg "install latest version of $pkg"
	go install "$pkg@latest"
}

go-install-packages() {
	msg "fetch some good and useful go packages"

	go-install-package github.com/yoheimuta/protolint/cmd/protolint
	go-install-package github.com/golangci/golangci-lint/cmd/golangci-lint
	go-install-package mvdan.cc/gofumpt
	go-install-package golang.org/x/tools/cmd/goimports
	go-install-package golang.org/x/tools/gopls

	msg "golangci-lint $(golangci-lint version)"
}
