#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : travis.sh
#
# [] Creation Date : 17-12-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: travis"
        echo "install travis command line client and ruby library"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        if $(hash gem 2>/dev/null); then
	        sudo gem install travis -v 1.8.9 --no-rdoc --no-ri
                travis version
        else
                echo "please install ruby first"
        fi

}
