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
        echo "installs required brew or apt packages"
}

# vim is depreated beacuase of neovim
# this env is not suitable for minimal systems
# please consider to install the required packages on these system by hand.

mac_packages=(zsh ctags tmux mosh aria2 neovim yamllint coreutils hub)
linux_packages=(zsh ctags tmux mosh aria2 curl yamllint snapd)
linux_snaps=(hub jq)

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
                if [ $have_proxy = true ]; then
                        proxy_start
                fi

                install-packages-osx ${mac_packages[@]}

                if [ $have_proxy = true ]; then
	                proxy_stop
                fi

                pip3 install neovim

        else
	        message "env" "Linux"

                install-packages-linux ${linux_packages[@]}
                install-snaps-linux ${linux_snaps[@]}

                message "env" "** Please install neovim by hands **"
        fi
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        install-
}
