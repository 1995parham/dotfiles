#!/bin/bash

usage() {
	echo -n -e "bluetooth tools and services\nbluez is not a t-shirt"

	# shellcheck disable=1004,2016
	echo '
 _     _
| |__ | |_   _  ___ ____
| |_ \| | | | |/ _ \_  /
| |_) | | |_| |  __// /
|_.__/|_|\__,_|\___/___|

  '
}

main_pacman() {
	require_pacman bluez bluez-utils bluez-tools
}

main() {
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service
}
