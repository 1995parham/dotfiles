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
        message "kubectl" "Install kubectl from brew"
        brew install kubernetes-cli
        
        message "kubectl" "Install helm from brew"
        brew install helm
        
        message "kubectl" "Install helmfile from brew"
        brew install helmfile
        
        message "kubectl" "Install stern (Multi pod and container log tailing for Kubernetes) from brew"
        brew install stern
        
        message "kubectl" "Validate your Kubernetes configuration files, supports multiple Kubernetes versions"
        brew install instrumenta/instrumenta/kubeval

		message "kubectl" "Argocd CLI"
		brew install argocd-cli
    else
        if [[ "$(command -v apt)" ]]; then
            echo "There is nothing that we can do right now"
        elif [[ "$(command -v pacman)" ]]; then
            message "kubectl" "install kubectl/helm/helmfile/argocd-cli with pacman"
            sudo pacman -Syu --noconfirm --needed  kubectl helm helmfile argocd-cli
            
            message "kubectl" "Install stern (Multi pod and container log tailing for Kubernetes) with yay"
            yay -Syu --noconfirm --needed stern-bin
            
            message "kubectl" "Validate your Kubernetes configuration files, supports multiple Kubernetes versions with yay"
            yay -Syu --noconfirm --needed kubeval-bin
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
            yay -Syu --noconfirm --needed okd-client-bin
        fi
        
    fi
}


main() {
    kube-install
    oc-install
}
