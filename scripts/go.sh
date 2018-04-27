#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : go.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

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

echo "[go] Fetch some good and useful go packages"
go get -v -u "github.com/alecthomas/gometalinter"
go get -v -u "github.com/nsf/gocode"
go get -v -u "github.com/garyburd/go-explorer/src/getool"
go get -v -u "github.com/golang/dep/cmd/dep"
go get -v -u "github.com/derekparker/delve/cmd/dlv"
go get -v -u "github.com/revel/revel"
go get -v -u "github.com/revel/cmd/revel"

echo "[go] Install binary requirements of vim-go"
vim -c 'GoUpdateBinaries' -c 'q' -c 'q'
