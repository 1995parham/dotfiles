#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : nest.sh
#
# [] Creation Date : 24-12-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: nest"
}

nest-install-cli() {
        # it requires sudo on linux based systems
        sudo npm install -g @nestjs/cli
        nest --version
}

nest-install-ts() {
        # it requires sudo on linux based systems
        sudo npm install -g typescript
        sudo npm install -g tslint
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        # check npm and node status
        if which node > /dev/null; then
                if [ $(node -v | cut -d '.' -f 1 | cut -b 2-) -lt 8 ]; then
                        echo "Please install node version 8.x at least"
                fi
                nest-install-cli
                nest-install-ts
        else
                echo "Please install node first"
                return 1
        fi
}
