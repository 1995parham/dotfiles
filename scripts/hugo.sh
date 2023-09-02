#!/bin/bash
usage() {
	echo "The world’s fastest framework for building websites"

	# shellcheck disable=1004,2016
	echo '
 _
| |__  _   _  __ _  ___
| |_ \| | | |/ _` |/ _ \
| | | | |_| | (_| | (_) |
|_| |_|\__,_|\__, |\___/
             |___/
  '
}

main_pacman() {
	require_pacman hugo
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	return 0
}
