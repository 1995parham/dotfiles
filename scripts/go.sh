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
	echo "usage: go [-i]"
        echo "  -i   install go first"
}

go-install() {
	message "go" "Installing go"

        brew install go

        message "go" "$(go version)"

	message "go" "Create go directory structure"
        local gopath
        gopath=$HOME/Documents/Go
        for dir in bin pkg src mod; do
                echo $dir
                [ -d $gopath/$dir ] || mkdir -p $gopath/$dir
        done
}

go-install-package() {
	go get -u $1

	if [ $? -eq 0 ]; then
		message "go" "$1 installation succeeded"
	else
		message "go" "$1 installation failed"
	fi
}

go-install-packages() {
        message "go" "Fetch some good and useful go packages"

	# Go Tools
	message "go" "Go Tools"
        # Linters Runner for Go. 5x faster than gometalinter. Nice colored output.
	go-install-package "github.com/golangci/golangci-lint/cmd/golangci-lint"

	# Go Debugger
        # vim-go adds dlv since v1.17 (March 27, 2018)
	# message "go" "Go Debugger [delve]"
	# go-install-package "github.com/derekparker/delve/cmd/dlv"

	message "go" "Install binary requirements of vim-go"
        # please consider that this script runs in bash so it cannot see
        # aliases that are defined in zsh
        nvim +GoUpdateBinaries +qall
}


main() {
        local install
        install=false

        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "i" argv; do
                case $argv in
                        i)
                                install=true
                                ;;
                esac
        done

        if [ $install = true ]; then
                go-install
        fi

        go-install-packages
}
