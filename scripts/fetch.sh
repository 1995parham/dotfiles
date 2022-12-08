#!/bin/bash

usage() {
	echo -n "a command-line system/repository information tool"
	# shellcheck disable=2016
	echo '
  __      _       _
 / _| ___| |_ ___| |__
| |_ / _ \ __/ __| |_ \
|  _|  __/ || (__| | | |
|_|  \___|\__\___|_| |_|
	'
}

main_pacman() {
	require_pacman neofetch onefetch tokei
}

main() {
	configfile neofetch
}
