#!/bin/bash

usage() {
	echo -n -e "sample for using ./start.sh\n" \
		"figlet for ascii art\n" \
		"you can use global variables that are listed below\n" \
		"- force\n" \
		"for more information see start.sh\n"

	# shellcheck disable=1004,2016
	echo '
                           _
 ___  __ _ _ __ ___  _ __ | | ___
/ __|/ _` | |_ ` _ \| |_ \| |/ _ \
\__ \ (_| | | | | | | |_) | |  __/
|___/\__,_|_| |_| |_| .__/|_|\___|
                    |_|
  '
}

main_apt() {
	return 1
}

main_pacman() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}
