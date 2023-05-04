#!/bin/bash

usage() {
	echo 'Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions'
	echo '
 _ ____   ___ __ ___
| |_ \ \ / / |_ | _ \
| | | \ V /| | | | | |
|_| |_|\_/ |_| |_| |_|
  '
}

main_pacman() {
	require_aur nvm
}

main() {
	if ! grep -q "source /usr/share/nvm/init-nvm.sh"; then
		echo 'source /usr/share/nvm/init-nvm.sh' >>~/.zshrc
	fi
}
