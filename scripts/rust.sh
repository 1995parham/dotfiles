#!/bin/
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: rust"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        curl https://sh.rustup.rs -sSf | sh
}
