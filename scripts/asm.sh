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
	echo "assembly with nasm and radare2, good old days"
	# shellcheck disable=2016,1004
	echo '
  __ _ ___ _ __ ___
 / _` / __| |_ ` _ \
| (_| \__ \ | | | | |
 \__,_|___/_| |_| |_|

  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm nasm rizin rz-cutter
}

main_apt() {
	sudo apt-get -y install nasm radare2
}
