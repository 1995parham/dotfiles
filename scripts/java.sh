#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : java.sh
#
# [] Creation Date : 27-09-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "queen needs spark, spark needs java"

	# shellcheck disable=1004,2016
	echo '
   _
  (_) __ ___   ____ _
  | |/ _` \ \ / / _` |
  | | (_| |\ V / (_| |
 _/ |\__,_| \_/ \__,_|
|__/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm jdk-openjdk
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}
