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
        echo "usage: python"
}

python-install() {
        message "python" "Installing Python 3.x"

        brew install python3
        python3 -m ensurepip

        message "python" "$(python3 --version)"
}

python-install-package() {
        python3 -mpip install -U $1

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
        python-install-package black
        python-install-package 'python-language-server[all]'
        python-install-package pyls-mypy
        python-install-package pylint
        python-install-package poetry
}

main() {
        python-install
        python-install-packages
}
