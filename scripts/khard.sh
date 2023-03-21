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
	if [ ! -d "$HOME/Documents/Git/parham/parham-alvani/" ]; then
		mkdir -p "$HOME/Documents/Git/parham/parham-alvani/"
	fi

	cd "$HOME/Documents/Git/parham/parham-alvani/" || return
	clone parham-alvani/addressbook git@github.com:
	cd - &>/dev/null || return
}
