#!/usr/bin/env bash

usage() {
	echo -n 'git configuration useful on systems with ssh keys and are used by @1995parham/@elahe-dastan'
	echo '
       _ _
  __ _(_) |_
 / _` | | __|
| (_| | | |_
 \__, |_|\__|
 |___/
  '
}

main_pacman() {
	return 0
}

main_brew() {
	return 0
}

main_apt() {
	return 0
}

main_parham() {
	configfile "git" "" "git/parham"
}

main_elahe() {
	configfile "git" "" "git/elahe"
}
