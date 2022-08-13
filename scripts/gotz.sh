#!/bin/bash

usage() {
	echo "timezone info in cli for working remotely"
	# shellcheck disable=2016
	echo '
             _
  __ _  ___ | |_ ____
 / _` |/ _ \| __|_  /
| (_| | (_) | |_ / /
 \__, |\___/ \__/___|
 |___/
  '
}

main_pacman() {
	require_aur gotz
}

main() {
	configfile gotz
}
