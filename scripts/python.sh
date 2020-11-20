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

packages=(
        flake8
        pep8-naming
        pipenv
        mypy
        black
        'python-language-server[all]'
        pyls-mypy
        pylint
        poetry

        pynvim
)

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

        git clone https://github.com/jawshooah/pyenv-default-packages.git $(pyenv root)/plugins/pyenv-default-packages || echo "pyenv-default-packages is already installed"
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

        printf "%s\n"${packages[@]} > $(pyenv root)/default-packages
        for package in ${packages[@]}; do
                python-install-package $package
        done
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
