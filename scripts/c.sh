#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : $file.name
#
# [] Creation Date : $time.strftime("%d-%m-%Y")
#
# [] Created By : $user.name ($user.email)
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
