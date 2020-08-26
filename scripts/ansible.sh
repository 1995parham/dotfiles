#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : ansible.sh
#
# [] Creation Date : 26-08-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


main() {
        # Reset optind between calls to getopts
        OPTIND=1

        brew install ansible
        pip3 install ansible-lint
}
