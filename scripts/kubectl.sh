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
	echo "k8s or openshift cluster is at your service on cli with these awesome commands"
	echo '
 _          _               _   _
| | ___   _| |__   ___  ___| |_| |
| |/ / | | | |_ \ / _ \/ __| __| |
|   <| |_| | |_) |  __/ (__| |_| |
|_|\_\\__,_|_.__/ \___|\___|\__|_|

	'
}

main_brew() {
	msg "kubectl"
	brew install kubernetes-cli

	msg "helm"
	brew install helm

	msg "helmfile"
	brew install helmfile

	msg "multi pod and container log tailing for Kubernetes"
	brew install stern

	msg "validate your Kubernetes configuration files, supports multiple Kubernetes versions"
	brew install instrumenta/instrumenta/kubeval

	msg "argocd cli"
	brew install argocd

	msg "openshift-cli"
	brew install openshift-cli

}

main_apt() {
	return 1
}

main_pacman() {
	msg "okd-client-bin"
	yay -Syu --noconfirm --needed okd-client-bin

	msg "kubectl/helm/helmfile/argocd-cli/kubectx"
	sudo pacman -Syu --noconfirm --needed kubectl helm helmfile argocd kubectx

	msg "multi pod and container log tailing for Kubernetes"
	yay -Syu --noconfirm --needed stern-bin

	msg "validate your Kubernetes configuration files, supports multiple Kubernetes versions"
	yay -Syu --noconfirm --needed kubeval-bin
}
