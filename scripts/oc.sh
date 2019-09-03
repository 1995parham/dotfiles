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

kube-install() {
        message "oc" "Install kubectl from brew"
        brew install kubernetes-cli
        message "oc" "Install helm from brew"
        brew install kubernetes-helm

}

oc-install() {
        message "oc" "Install openshift-cli from brew"
        brew install openshift-cli
}


main() {
        # Reset optind between calls to getopts
        OPTIND=1

        kube-install
        oc-install
}
