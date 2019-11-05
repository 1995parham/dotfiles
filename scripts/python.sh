#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
verbose=false

usage() {
        echo "usage: python [-i] [-v]"
        echo "  -i   install python first"
        echo "  -v   verbose"
}

python-install() {
        message "python" "Installing Python 3.x"

        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "python" "Darwin"

                brew install python3
        else
                message "python" "Linux"

                sudo apt-get -y install python3
        fi
        python3 -m ensurepip

        message "python" "$(python3 --version)"
}

python-install-package() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                pip3 install -U $1
        else
                sudo pip3 install -U $1
        fi

        if [ $? -eq 0 ]; then
                message "python" "$1 installation succeeded"
        else
                message "python" "$1 installation failed"
        fi
}

python-install-packages() {
        message "python" "Fetch some good and useful python packages"

        message "python" "Python Tools"
        python-install-package flake8
        python-install-package pep8-naming
        python-install-package pipenv
        python-install-package mypy
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "iv" argv; do
                case $argv in
                        i)
                                python-install
                                ;;
                        v)
                                verbose=true
                                ;;
                esac
        done

        python-install-packages
}
