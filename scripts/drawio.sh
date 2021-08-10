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
	echo -n -e "sample for using ./start.sh\n"

	# shellcheck disable=1004,2016
	echo '
     _                    _
  __| |_ __ __ ___      _(_) ___
 / _` | |__/ _` \ \ /\ / / |/ _ \
| (_| | | | (_| |\ V  V /| | (_) |
 \__,_|_|  \__,_| \_/\_/ |_|\___/

  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu drawio-desktop-bin
}

main_brew() {
	brew install --cask drawio
}
