#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : stm.sh
#
# [] Creation Date : 25-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# shellcheck disable=2034
dependencies="rust"

usage() {
	echo -n -e "have fun with stm discovery board and the lovely rust"

	# shellcheck disable=1004,2016
	echo '
     _
 ___| |_ _ __ ___
/ __| __| |_ ` _ \
\__ \ |_| | | | | |
|___/\__|_| |_| |_|

  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm arm-none-eabi-gdb \
		minicom \
		openocd \
		bluez \
		bluez-utils \
		tinygo \
		rfkill

	rustup component add llvm-tools-preview
	rustup target add thumbv7em-none-eabihf
	cargo install cargo-binutils

	lsusb | grep ST-LINK
}
