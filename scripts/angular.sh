#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: angular"
}

angular-install-cli() {
        # it requires sudo on linux based systems
        sudo npm install -g @angular/cli
        ng --version
}

angular-install-ts() {
        # it requires sudo on linux based systems
        sudo npm install -g typescript
        sudo npm install -g tslint
}

main() {
        # reset optind between calls to getopts
        OPTIND=1

        # check npm and node status
        if which node > /dev/null; then
                if [ $(node -v | cut -d '.' -f 1 | cut -b 2-) -lt 8 ]; then
                        echo "Please install node version 8.x at least"
                fi
                angular-install-cli
                angular-install-ts
        else
                echo "Please install node first"
                return 1
        fi
}
