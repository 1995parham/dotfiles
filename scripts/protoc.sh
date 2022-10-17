#!/bin/bash

usage() {
	echo "protocol buffer from google"
	echo '
                 _
 _ __  _ __ ___ | |_ ___   ___
| |_ \| |__/ _ \| __/ _ \ / __|
| |_) | | | (_) | || (_) | (__
| .__/|_|  \___/ \__\___/ \___|
|_|
  '
}

main_brew() {
	msg "installing protobuf from brew with go bindings"
	brew install protobuf
	brew install protoc-gen-go
}

main_pacman() {
	msg "installing protobuf from pacman with go bindings"

	require_pacman protobuf
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
}
