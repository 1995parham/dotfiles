#!/usr/bin/env bash

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
    require_brew go operator-sdk
}

main_apt() {
    require_apt golang-go
}

main_pacman() {
    require_pacman go operator-sdk
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
    go env -w GOPROXY=https://proxy.golang.org,direct
    # go env -w GOPROXY="direct"
    # go env -w GOPROXY="https://goproxy.io,goproxy.cn,direct"
    # go env -w GOPROXY="https://goproxy.cn,direct"
    go env -w GONOSUMDB="gitlab.snapp.ir"
    # go env -w GOSUMDB="sum.golang.org"
    go env -w GOSUMDB="off"
    go env -w GOPRIVATE="gitlab.snapp.ir"

    go env

    go-install-packages
}

go-install-packages() {
    msg "fetch some good and useful go packages"

    require_go github.com/golangci/golangci-lint/v2/cmd/golangci-lint
    require_go mvdan.cc/gofumpt
    require_go golang.org/x/tools/cmd/goimports
    require_go golang.org/x/tools/gopls
    require_go golang.org/dl/gotip
    require_go github.com/go-delve/delve/cmd/dlv
    # require_go github.com/google/wire/cmd/wire
    require_go github.com/abice/go-enum
    require_go github.com/swaggo/swag/cmd/swag
    require_go golang.org/x/tools/cmd/gonew

    msg "golangci-lint $(golangci-lint version)"
}
