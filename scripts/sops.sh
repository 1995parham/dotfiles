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
	echo -n -e "simple and flexible tool for managing secrets"

	# shellcheck disable=1004,2016
	echo '
 ___  ___  _ __  ___
/ __|/ _ \| |_ \/ __|
\__ \ (_) | |_) \__ \
|___/\___/| .__/|___/
          |_|
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm sops
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	msg "there is nothing that we can do"
	return 1
}
