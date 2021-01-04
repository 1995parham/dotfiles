#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : env.sh
#
# [] Creation Date : 07-01-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
usage() {
        echo "usage: env"
        echo "installs required brew/apt packages"
}

mac_packages=(zsh tmux aria2 neovim yamllint coreutils jq k6 htop)
apt_packages=(htop atop zsh aria2 curl tmux bat neovim python3-pynvim jq yamllint bmon)
pacman_packages=(htop atop zsh aria2 curl tmux bat neovim python-pynvim jq yamllint)
pkg_packages=(neovim zsh tmux vim python ncurses-utils)


install-brew() {
        if brew ls --versions "$1" > /dev/null; then
                message "env" "update $1 with brew"
                brew upgrade "$1"
        else
                message "env" "install $1 with brew"
                brew install "$1"
        fi
}

install-packages-osx() {
        for pkg in $@; do
                install-brew $pkg
        done
}

install-packages-linux() {
        if [[ "$(command -v apt)" ]]; then
                sudo apt-get update -q

                message "env" "install ${apt_packages[*]} with apt"
                sudo apt-get install ${apt_packages[@]}
        elif [[ "$(command -v pacman)" ]]; then
                message "env" "install ${pacman_packages[*]} with pacman"
                sudo pacman -Syu --noconfirm --needed ${pacman_packages[@]}
        fi
}

install-() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "env" "Darwin"
                install-packages-osx ${mac_packages[@]}
                python3 -mpip install pynvim
        elif [[ "$OSTYPE" == "linux-android" ]]; then
                message "env" "install ${pkg_packages[*]} with pkg (termux on Android)"
                pkg install ${pkg_packages[@]}
                python3 -mpip install pynvim
        else
                message "env" "Linux"

                install-packages-linux
        fi
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        install-
}
