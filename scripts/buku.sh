#!/bin/bash

usage() {
	echo -n "personal mini-web in text"
	# shellcheck disable=2016,2028
	echo '
 _           _
| |__  _   _| | ___   _
| |_ \| | | | |/ / | | |
| |_) | |_| |   <| |_| |
|_.__/ \__,_|_|\_\\__,_|
	'
}

export dependencies=('python')

main_pacman() {
	return 0
}

main() {
	require_pip buku

	msg 'refer to the tabs repository for further instruactions'
}