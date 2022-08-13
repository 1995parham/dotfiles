#!/bin/bash

usage() {
	echo "console carddav client"
	# shellcheck disable=2016
	echo '
 _    _           _
| | _| |__   __ _| |
| |/ / |_ \ / _| | |
|   <| | | | (_| | |
|_|\_\_| |_|\__,_|_|
  '
}

main_pacman() {
	require_pacman khal
}

main() {
	configfile khal config

	git clone git@github.com:parham-alvani/calendar.git "$HOME/Documents/Git/parham/parham-alvani/calendar" || true
}
