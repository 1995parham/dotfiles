#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : zig.sh
#
# [] Creation Date : 06-08-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n -e "Zig is a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."

	# shellcheck disable=1004,2016
	echo '
     _
 ___(_) __ _
|_  / |/ _` |
 / /| | (_| |
/___|_|\__, |
       |___/
  '
}

main_apt() {
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm zig
}

main_brew() {
	brew install zig
}
