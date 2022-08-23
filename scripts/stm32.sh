#!/bin/bash

export dependencies=("rust")

usage() {
	echo -n -e "have fun with stm32 discovery board and the lovely rust and c"

	# shellcheck disable=1004,2016
	echo '
     _             _________
 ___| |_ _ __ ___ |___ /___ \
/ __| __| |_ | _ \  |_ \ __) |
\__ \ |_| | | | | |___) / __/
|___/\__|_| |_| |_|____/_____|

  '
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm \
		arm-none-eabi-gdb \
		arm-none-eabi-gcc \
		arm-none-eabi-binutils \
		arm-none-eabi-newlib \
		minicom \
		openocd \
		bluez \
		bluez-utils \
		tinygo \
		stlink \
		rfkill

	msg 'as a real man you can compile your gcc/binutils/gdb/newlib with crosstool-ng'

	msg 'we are going to install the rust tools for stm32'

	rustup component add llvm-tools-preview
	rustup target add thumbv7em-none-eabihf
	cargo install cargo-binutils

	msg 'do you have any stlink connected?'

	lsusb | grep ST-LINK
}
