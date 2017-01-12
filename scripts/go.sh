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
if [ $OSTYPE == "linux"* ]; then
	sudo apt-get install golang
fi

echo "[go] Create go directory structure"
if [ ! -d $HOME/Documents/Go ]; then
	mkdir $HOME/Documents/Go
	mkdir $HOME/Documents/Go/bin
	mkdir $HOME/Documents/Go/src
	mkdir $HOME/Documents/Go/lib
fi

go get -u github.com/jstemmer/gotags
go get -u github.com/nsf/gocode
go get -u github.com/garyburd/go-explorer/src/getool
go get -u golang.org/x/tools/cmd/goimports
