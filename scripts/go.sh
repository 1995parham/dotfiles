#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : go.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
verbose=false
beta=false

usage() {
	echo "usage: go [-i] [-b [-v]"
        echo "  -i   install go first"
        echo "  -b   install beta version"
	echo "  -v   verbose"
}

go-install() {
	message "go" "Installing go"

	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "go" "Linux"

                if [ $beta = true ]; then
                        message "go" "beta version installation"
                        sudo snap install go --beta --classic
                else
                        message "go" "stable version installation"
                        sudo snap install go --classic
                fi
	else
		message "go" "Darwin"

		brew install go
	fi
        message "go" "$(go version)"

	message "go" "Create go directory structure"
        local gopath
        gopath=$HOME/Documents/Go
        for dir in bin pkg src mod; do
                echo $dir
                [ -d $gopath/$dir ] || mkdir -p $gopath/$dir
        done
}

go-install-dep() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "go" "Linux"

                curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
	else
		message "go" "Linux"

                brew install dep
	fi
        message "go" "$(dep version)"
}

go-install-package() {
	if [ $verbose = true ]; then
		go get -v -u $1
	else
		go get -u $1
	fi
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
        # vim-go installs go-metalinter
	# go-install-package "github.com/alecthomas/gometalinter"
	go-install-package "github.com/nsf/gocode"
	go-install-package "github.com/garyburd/go-explorer/src/getool"

	# Go Debugger
        # vim-go adds dlv since v1.17 (March 27, 2018)
	# message "go" "Go Debugger [delve]"
	# go-install-package "github.com/derekparker/delve/cmd/dlv"

	# Revel web framework
	read -p "Do you wish to install Revel web framework? [Y/n] " install_confirm
	case $install_confirm in
		Y )
			message "go" "Revel web framework"
			go-install-package "github.com/revel/revel"
			go-install-package "github.com/revel/cmd/revel"
			;;
        esac

        # Buffalo awesome web framework
        read -p "Do you wish to install Buffalo web framework? [Y/n] " install_confirm
        case $install_confirm in
		Y )
			message "go" "Buffalo web framework"
			go-install-package "github.com/gobuffalo/buffalo/buffalo"
			;;
        esac

	message "go" "Install binary requirements of vim-go"
        vim +GoUpdateBinaries +qall
}


main() {
        local install
        install=false

        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "ivb" argv; do
                case $argv in
                        b)
                                beta=true
                                ;;
                        i)
                                install=true
                                ;;
                        v)
                                verbose=true
                                ;;
                esac
        done

        if [ $install = true ]; then
                go-install
        fi

        go-install-dep

        if [ $have_proxy = true ]; then
                proxy_start
        fi

        go-install-packages

        if [ $have_proxy = true ]; then
                proxy_stop
        fi
}
