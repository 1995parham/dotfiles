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
	chown -R $USER:$USER $HOME/Documents/Go
fi

echo "[go] Fetch some good and useful go packages"
go get -u -v github.com/alecthomas/gometalinter
go get -u -v github.com/nsf/gocode
go get -u -v github.com/garyburd/go-explorer/src/getool
go get -u -v github.com/golang/dep/cmd/dep
gometalinter --install

echo "[go] Install binary requirements of vim-go"
vim -c 'GoUpdateBinaries' -c 'q' -c 'q'
