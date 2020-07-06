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

mac_packages=(zsh ctags tmux aria2 neovim yamllint coreutils jq k6)
linux_packages=(clang zsh ctags aria2 curl python3-pip python3-setuptools)
linux_brews=(tmux yamllint jq neovim k6)
linux_snaps=()

install-apt() {
        if [ $force = false ]; then
                sudo apt-get install $1
        else
                sudo apt-get install $1 -y
        fi
}

install-brew() {
        if $(brew ls --versions "$1" > /dev/null); then
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
	sudo apt-get update -q
        for pkg in $@; do
                message "env" "install $pkg with apt"
                install-apt $pkg
        done
}

install-snaps-linux() {
        for snap in $@; do
                message "env" "install $snap with snapp"
                sudo snap install $snap --classic
        done
}

install-() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "env" "Darwin"

                install-packages-osx ${mac_packages[@]}
        else
	        message "env" "Linux"

                # setup shell environments for linuxbrew.
                test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
                test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

                if ! hash brew 2>/dev/null; then
                        message "env" "Please install linuxbrew with './start.sh brew'"
                        exit 1
                fi

                install-packages-linux ${linux_packages[@]}
                install-snaps-linux ${linux_snaps[@]}
                install-packages-osx ${linux_brews[@]}
        fi

        python3 -mpip install neovim
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        install-
}
