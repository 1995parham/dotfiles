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
	echo "usage: c"
}

main() {
	message "c" "Installing clang + cmake"

	if [[ "$OSTYPE" == "darwin"* ]]; then
		message "c" "Darwin"

		brew install clang-format
		brew install cmake
	else
		message "c" "Linux"

		sudo apt-get -y install clang clang-format
		sudo apt-get -y install cmake
	fi
}
