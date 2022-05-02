#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : c.sh
#
# [] Creation Date : 25-09-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo "clang, cmake without prof.bakhshi :("
	echo '
  ___
 / __|
| (__
 \___|

  '
}

main_pacman() {
	msg 'install clang and clangd'
	sudo pacman -Syu --needed --noconfirm clang cmake valgrind meson
}

main_brew() {
	brew install clang-format
	brew install cmake
}

main_apt() {
	sudo apt -y install clang clang-format
	sudo apt -y install cmake
}
