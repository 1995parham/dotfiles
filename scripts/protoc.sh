#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : protoc.sh
#
# [] Creation Date : 11-04-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: protoc"
}

main() {
	message "protoc" "Installing protobuf"
	brew install protobuf
	brew install protoc-gen-go
}
