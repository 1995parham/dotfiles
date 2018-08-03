#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
version="10.x"

usage() {
        echo "usage: node"
}


node-install() {
        message "node" "Installing Node $version"

        if [[ "$OSTYPE" == "darwin"* ]]; then
	        echo "[node] Darwin"

	        brew install node
	        brew install yarn
        else
	        echo "[node] Linux"

	        curl -sL https://deb.nodesource.com/setup_$version | sudo -E bash -
	        sudo apt-get install -y nodejs
	        ln -s /usr/bin/nodejs /usr/bin/node
        fi

        message "node" "$(node -v)"
}

main() {
        node-install
}
