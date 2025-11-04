#!/usr/bin/env bash

usage() {
    echo -n "setup working environment for go with neovim"
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
    if ! command -v go &>/dev/null; then
        msg 'go is not available in PATH' 'error'
        return 1
    fi
    msg "$(go version)"

    msg "create go directories structure"
    local gopath="$HOME/.cache/go"
    if [ ! -d "$gopath" ]; then
        if ! mkdir -p "$gopath"; then
            msg 'failed to create GOPATH directory' 'error'
            return 1
        fi
    fi

    local gobin="$HOME/.local/bin"
    if [ ! -d "$gobin" ]; then
        if ! mkdir -p "$gobin"; then
            msg 'failed to create GOBIN directory' 'error'
            return 1
        fi
    fi

    msg "configure go environment variables"

    go_env GOPATH "$HOME/.cache/go"
    go_env GOBIN "$HOME/.local/bin"
    go_env GOPROXY https://proxy.golang.org,direct
    go_env GOSUMDB "sum.golang.org" # Use official Go checksum database

    go_env GONOSUMDB "gitlab.snapp.ir"
    go_env GOPRIVATE "gitlab.snapp.ir"

    # Alternative GOPROXY configurations (uncomment if needed):
    # go_env GOPROXY "direct"  # Direct access only (no proxy)
    # go_env GOPROXY "https://goproxy.io,goproxy.cn,direct"  # Chinese mirrors
    # go_env GOPROXY "https://goproxy.cn,direct"  # Aliyun mirror

    # Alternative GOSUMDB configuration:
    # go_env GOSUMDB "off"

    go env

    go_install_packages
}

go_env() {
    local name=$1
    local value=$2

    if ! go env -w "${name}=${value}"; then
        msg 'failed to configure go environment' 'error'
        return 1
    fi
}

go_install_packages() {
    msg "fetch some good and useful go packages"

    require_go github.com/golangci/golangci-lint/v2/cmd/golangci-lint
    require_go mvdan.cc/gofumpt
    require_go golang.org/x/tools/cmd/goimports
    require_go golang.org/x/tools/gopls
    require_go golang.org/dl/gotip
    require_go github.com/go-delve/delve/cmd/dlv
    require_go github.com/pressly/goose/v3/cmd/goose
    # Wire dependency injection tool (commented - enable if needed)
    # require_go github.com/google/wire/cmd/wire
    require_go github.com/abice/go-enum
    require_go github.com/swaggo/swag/cmd/swag
    require_go golang.org/x/tools/cmd/gonew

    if command -v golangci-lint &>/dev/null; then
        msg "golangci-lint $(golangci-lint version)"
    else
        msg 'golangci-lint not available in PATH' 'error'
    fi
}
