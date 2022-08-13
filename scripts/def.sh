#!/bin/bash

usage() {
	echo "def, a free oxford dictionary (based on stardict) in terminal"
	echo '
     _       __
  __| | ___ / _|
 / _` |/ _ \ |_
| (_| |  __/  _|
 \__,_|\___|_|

  '
}

main_pacman() {
	require_pacman sdcv
	require_aur stardict-oald
}

main_brew() {
	return 1
}

main_apt() {
	return 1
}
