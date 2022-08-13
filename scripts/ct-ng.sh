#!/bin/bash

usage() {
	echo -n -e "crosstool-ng for cross compiling"

	# shellcheck disable=1004,2016
	echo '
      _
  ___| |_      _ __   __ _
 / __| __|____| |_ \ / _` |
| (__| ||_____| | | | (_| |
 \___|\__|    |_| |_|\__, |
                     |___/

 '
}

main_pacman() {
	require_pacman help2man
}

main() {
	mkdir "$HOME/.cache" || true

	cd "$HOME/.cache" || exit
	git clone https://github.com/crosstool-ng/crosstool-ng || true
	cd crosstool-ng || exit
	./bootstrap
	./configure --prefix="/usr/local"
	make
	sudo make install

	msg "the workspace for using crosstool"
	mkdir -p "$HOME/Documents/crosstool" || true
}
