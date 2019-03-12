#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : oc.sh
#
# [] Creation Date : 12-03-2019
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: oc"
}

oc-install() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "oc" "Linux"
	else
		message "forticlient" "Darwin"

                message "forticlient" "Install openshift-cli from brew"
		brew install openshift-cli
	fi
}


main() {
        # Reset optind between calls to getopts
        OPTIND=1

        oc-install
}
