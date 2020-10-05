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
        if [[ "$OSTYPE" == "darwin"* ]]; then
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
        else
		if [[ "$(command -v apt)" ]]; then
			echo "There is nothing that we can do right now"
		elif [[ "$(command -v pacman)" ]]; then
			message "kubectl" "install kubectl helm with pacman"
			sudo pacman -Syu --noconfirm --needed  kubectl helm

			message "kubectl" "Install stern (Multi pod and container log tailing for Kubernetes) with yay"
			yay -Syu --noconfirm --needed stern-bin
		fi

        fi
}

oc-install() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
		message "kubectl" "Install openshift-cli from brew"
		brew install openshift-cli
        else
		if [[ "$(command -v apt)" ]]; then
			echo "There is nothing that we can do right now"
		elif [[ "$(command -v pacman)" ]]; then
			message "kubectl" "install origin-client-bin with yay"
			yay -Syu --noconfirm --needed origin-client-bin
		fi

        fi
}


main() {
        kube-install
        oc-install
}
