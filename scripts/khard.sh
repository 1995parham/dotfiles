#!/bin/bash

usage() {
	echo "console carddav client"
	# shellcheck disable=2016
	echo '
 _    _                   _
| | _| |__   __ _ _ __ __| |
| |/ / |_ \ / _| | |__/ _| |
|   <| | | | (_| | | | (_| |
|_|\_\_| |_|\__,_|_|  \__,_|
  '
}

main_pacman() {
	require_pacman khard
}

main() {
	configfile khard khard.conf
}

main_parham() {
	clone git@github.com:parham-alvani/addressbook "$HOME/Documents/Git/parham/parham-alvani/"
}
