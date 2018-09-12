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

mac_packages=(zsh ctags tmux mosh aria2 neovim yamllint)
linux_packages=(zsh ctags tmux mosh aria2 jq curl yamllint snapd)

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

install() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
	        message "env" "Darwin"
                if [ $have_proxy = true ]; then
                        proxy_start
                fi

                install-packages-osx ${mac_packages[@]}

                if [ $have_proxy = true ]; then
	                proxy_stop
                fi

        else
	        message "env" "Linux"

                install-packages-linux ${linux_packages[@]}

                sudo add-apt-repository ppa:neovim-ppa/stable -y

                install-packages-linux neovim python3-dev python3-pip
        fi

        if $(hash gdate 2>/dev/null); then
	        gem install travis -v 1.8.8 --no-rdoc --no-ri
        fi

        pip3 install --upgrade neovim
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        install
}
