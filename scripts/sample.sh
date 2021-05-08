#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

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
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	msg "there is nothing that we can do"
	return 1
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "there is nothing that we can do"
	return 1
}
