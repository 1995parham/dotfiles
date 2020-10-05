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

pyenv-install() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "python" "Darwin"

                brew install pyenv
        else
                message "python" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "python" "install pyenv with pacman"
                        sudo pacman -Syu --needed --noconfirm pyenv
                fi
        fi
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
        pyenv-install

        if [[ "$(command -v pyenv)" ]]; then
                pyenv versions
        fi

        read -p "[python] do you want to install useful packages ?[Y/n] " -n 1 confirm; echo

        if [[ $confirm == "Y" ]]; then
                python-install-packages
        fi
}
