#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : exercism.sh
#
# [] Creation Date : 30-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
usage() {
	echo "exercism"
	# shellcheck disable=1004
	echo '
                        _
  _____  _____ _ __ ___(_)___ _ __ ___
 / _ \ \/ / _ \ |__/ __| / __| |_ ` _ \
|  __/>  <  __/ | | (__| \__ \ | | | | |
 \___/_/\_\___|_|  \___|_|___/_| |_| |_|
	'
}

main_brew() {
	brew install exercism
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu --needed --noconfirm exercism-bin
}
