#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : key.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: key [name]"
        echo "install private key of given name"
        echo "Parham Alvani is the only one who authorized"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if [ -s $1 ]; then
                usage
                return
        fi

        git clone https://github.com/1995parham/keys

        if [ ! -d $HOME/.ssh ]; then
                mkdir $HOME/.ssh && chmod 0700 $HOME/.ssh
        fi
        if [ ! -d keys/$1 ]; then
                echo "$1 does not exists on keys"
                rm -Rf keys
                return
        fi

        cp keys/$1/id_rsa $HOME/.ssh && chmod 0600 $HOME/.ssh/id_rsa
        cp keys/$1/id_rsa.pub $HOME/.ssh && chmod 0644 $HOME/.ssh/id_rsa.pub
        rm -Rf keys
}
