#!/bin/bash

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
	require_pacman clang cmake valgrind meson bear
}

main_brew() {
	brew install clang-format
	brew install cmake
}

main_apt() {
	sudo apt -y install clang clang-format
	sudo apt -y install cmake
}
