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
	
	sudo apt-get install golang
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

echo "[go] Install binary requirements of vim-go"
vim -c 'GoUpdateBinaries' -c 'q' -c 'q'
