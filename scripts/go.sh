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
version="1.10"

usage() {
	echo "usage: go-$version [-i] [-v]"
	echo "  -i   install go first"
	echo "  -v   verbose"
}

go-install() {
	message "go" "Installing go"

	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "go" "Linux"

		sudo add-apt-repository -y ppa:gophers/archive
		sudo apt-get -y update
		sudo apt-get -y install golang-$version-go

		sudo ln -f -s /usr/lib/go-$version/bin/go /usr/bin/go
		sudo ln -f -s /usr/lib/go-$version/bin/gofmt /usr/bin/gofmt
	else
		message "go" "Darwin"

		brew install go
	fi

	message "go" "Create go directory structure"
	if [ ! -d $HOME/Documents/Go ]; then
		mkdir $HOME/Documents/Go
		mkdir $HOME/Documents/Go/bin
		mkdir $HOME/Documents/Go/src
		mkdir $HOME/Documents/Go/lib
	fi
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
	go-install-package "github.com/alecthomas/gometalinter"
	go-install-package "github.com/nsf/gocode"
	go-install-package "github.com/garyburd/go-explorer/src/getool"

	# Go Dep
	message "go" "Go Dep"
	go-install-package "github.com/golang/dep/cmd/dep"

	# Go Debugger
	message "go" "Go Debugger [delve]"
	go-install-package "github.com/derekparker/delve/cmd/dlv"

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
        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "iv" argv; do
	        case $argv in
		        i)
			        go-install
			        ;;
		        v)
			        verbose=true
			        ;;
	        esac
        done

        if [ $have_proxy = true ]; then
	        proxy_start
        fi

        go-install-packages

        if [ $have_proxy = true ]; then
	        proxy_stop
        fi
}
