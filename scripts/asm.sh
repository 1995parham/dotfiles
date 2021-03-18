#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : asm.sh
#
# [] Creation Date : 30-06-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "usage: asm"
}

main() {
	message "asm" "Installing nasm + radare2"

	sudo apt-get -y install nasm radare2
}
