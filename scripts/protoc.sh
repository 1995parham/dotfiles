#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : protoc.sh
#
# [] Creation Date : 13-04-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: protoc"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        brew install protobuf
        brew install protoc-gen-go
}
