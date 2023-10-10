#!/bin/bash
usage() {
	echo "Atlas is a language-independent tool for managing and migrating database schemas using modern DevOps principles."

	# shellcheck disable=1004,2016
	echo '
       _   _
  __ _| |_| | __ _ ___
 / _` | __| |/ _` / __|
| (_| | |_| | (_| \__ \
 \__,_|\__|_|\__,_|___/
  '
}

main_pacman() {
	return 0
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

main() {
	msg 'download and install the latest release of the atlas cli'
	curl -sSf https://atlasgo.sh | sh
}
