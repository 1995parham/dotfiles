#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
version="12.x"

usage() {
        echo "usage: node"
}


node-install() {
        message "node" "Installing Node $version"

        if hash brew 2>/dev/null; then
	        echo "[node] with brew"

	        brew install node
	        brew install yarn
        else
	        echo "[node] with apt"

	        curl -sL https://deb.nodesource.com/setup_$version | sudo -E bash -
	        sudo apt-get install -y nodejs
	        sudo ln -s /usr/bin/nodejs /usr/bin/node
        fi

        message "node" "$(node -v)"
}

main() {
        node-install
}
