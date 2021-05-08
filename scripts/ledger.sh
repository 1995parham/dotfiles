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
	echo -n 'ledger hardware wallet management software and udev rules'
	# shellcheck disable=2016
	echo '
 _          _
| | ___  __| | __ _  ___ _ __
| |/ _ \/ _` |/ _` |/ _ \ |__|
| |  __/ (_| | (_| |  __/ |
|_|\___|\__,_|\__, |\___|_|
              |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --noconfirm --needed ledger-live-bin
}

main_brew() {
	brew install ledger-live
}
