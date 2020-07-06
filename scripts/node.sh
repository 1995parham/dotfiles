#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : node.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
usage() {
        echo "usage: node"
}


node-install() {
        message "node" "Installing Node $version"

        echo "[node] with brew"

        brew install node

        message "node" "$(node -v)"
}

main() {
        node-install
}
