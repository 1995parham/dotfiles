#!/bin/bash

usage() {
	echo -n "An open source cross-platform alternative to AirDrop"
	# shellcheck disable=2016
	echo '
 _                 _                    _ 
| | ___   ___ __ _| |___  ___ _ __   __| |
| |/ _ \ / __/ _| | / __|/ _ \ |_ \ / _| |
| | (_) | (_| (_| | \__ \  __/ | | | (_| |
|_|\___/ \___\__,_|_|___/\___|_| |_|\__,_|

	'
}

main_pacman() {
	require_aur localsend-bin
}
