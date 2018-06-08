#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : go.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
program_name=$0

have_proxy=false
verbose=false

usage() {
	echo "usage: $program_name [-i] [-h] [-p] [-v]"
	echo "  -i   install go first"
	echo "  -p   use backtory proxy for package installation"
	echo "  -v   verbos"
	echo "  -h   display help"
}

install_go() {
	echo "[go] Installing go"

	if [[ $OSTYPE == "linux-gnu" ]]; then
		echo "[go] Linux"

		if [[ $EUID -eq 0 ]]; then
			echo "[docker] This script must be run as normal user"
			exit 1
		fi

		sudo add-apt-repository -y ppa:gophers/archive
		sudo apt-get update
		sudo apt-get install golang-1.10-go

		sudo ln -f -s /usr/lib/go-1.10/bin/go /usr/bin/go
		sudo ln -f -s /usr/lib/go-1.10/bin/gofmt /usr/bin/gofmt
	else
		echo "[go] Darwin"

		brew install go
	fi

	echo "[go] Create go directory structure"
	if [ ! -d $HOME/Documents/Go ]; then
		mkdir $HOME/Documents/Go
		mkdir $HOME/Documents/Go/bin
		mkdir $HOME/Documents/Go/src
		mkdir $HOME/Documents/Go/lib

		if [[ $OSTYPE == "linux-gnu" ]]; then
			sudo chown -R $USER:$USER $HOME/Documents/Go
		fi
	fi
}

set_proxy() {
	echo "[go] set backtory proxy"
	export http_proxy=http://fod.backtory.com:8118/
	export https_proxy=http://fod.backtory.com:8118/
}

unset_proxy() {
	echo "[go] unset backtory proxy"
	unset http_proxy
	unset https_proxy
}

install_go_package() {
	if [ $verbose = true ]; then
		go get -v -u $1
	else
		go get -u $1
	fi
	if [ $? -eq 0 ]; then
		echo "$1 installation succeeded"
	else
		echo "$1 installation failed"
	fi
}

install_go_packages() {
	echo "[go] Fetch some good and useful go packages"

	# Go Tools
	echo "[go] Go Tools"
	install_go_package "github.com/alecthomas/gometalinter"
	install_go_package "github.com/nsf/gocode"
	install_go_package "github.com/garyburd/go-explorer/src/getool"

	# Go Dep
	echo "[go] Go Dep"
	install_go_package "github.com/golang/dep/cmd/dep"

	# Go Debugger
	echo "[go] Go Debugger [delve]"
	install_go_package "github.com/derekparker/delve/cmd/dlv"

	# Revel web framework
	echo "[go] Revel web framework"
	install_go_package "github.com/revel/revel"
	install_go_package "github.com/revel/cmd/revel"

	echo "[go] Install binary requirements of vim-go"
	# vim -c 'GoUpdateBinaries' -c 'q' -c 'q'
}

while getopts "ihpv" argv; do
	case $argv in
		i)
			install_go
			;;
		p)
			have_proxy=true
			;;
		v)
			verbose=true
			;;
		h)
			usage
			exit
			;;
	esac
done

if [ $have_proxy = true ]; then
	set_proxy
fi

install_go_packages

if [ $have_proxy = true ]; then
	unset_proxy
fi
