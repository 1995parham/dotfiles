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
        brew install helm

        message "oc" "Install stern (Multi pod and container log tailing for Kubernetes) from brew"
        brew install stern

        message "oc" "Install kubespy (Tools for observing Kubernetes resources in real time) from brew"
        brew install kubespy

	message "oc" "Validate your Kubernetes configuration files, supports multiple Kubernetes versions"
	brew install instrumenta/instrumenta/kubeval
}

oc-install() {
        message "oc" "Install openshift-cli from brew"
        brew install openshift-cli
}


main() {
        kube-install
        oc-install
}
