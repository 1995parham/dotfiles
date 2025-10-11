#!/usr/bin/env pwsh

function Get-Usage {
    return @"
setup working environment for go with neovim
  __ _  ___
 / _` |/ _ \
| (_| | (_) |
 \__, |\___/
 |___/
"@
}

function main_winget {
    Require-Winget -Packages @("GoLang.Go")
}

function main {
    msg "fetch some good and useful go packages"

    Require-Go github.com/golangci/golangci-lint/v2/cmd/golangci-lint
    Require-Go mvdan.cc/gofumpt
    Require-Go golang.org/x/tools/cmd/goimports
    Require-Go golang.org/x/tools/gopls
    Require-Go golang.org/dl/gotip
    Require-Go github.com/go-delve/delve/cmd/dlv
    # Wire dependency injection tool (commented - enable if needed)
    # Require-Go github.com/google/wire/cmd/wire
    Require-Go github.com/abice/go-enum
    Require-Go github.com/swaggo/swag/cmd/swag
    Require-Go golang.org/x/tools/cmd/gonew
}