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

kubeval-upstall() {
        message "kubeval" "Upstall kubeval from github"
	kubeval_vr=$(curl -s https://api.github.com/repos/instrumenta/kubeval/releases/latest | grep 'tag_name' | cut -d\" -f4)
        kubeval_vl=''
        if hash kubeval 2> /dev/null; then
                kubeval_vl=$(kubeval --version | grep Version | cut -d' ' -f2)
        fi

        if [[ $kubeval_vr != $kubeval_vl ]]; then
                message "kubeval" "Dowloading from github"
                curl -L https://github.com/instrumenta/kubeval/releases/download/${kubeval_vr}/kubeval-$(uname -s | awk '{print tolower($0)}')-amd64.tar.gz | tar -zxOf - kubeval | sudo tee /usr/local/bin/kubeval > /dev/null
                sudo chmod +x /usr/local/bin/kubeval
        fi

        message "kubeval" "$(kubeval --version)"
}


kube-install() {
        message "oc" "Install kubectl from brew"
        brew install kubernetes-cli

        message "oc" "Install helm from brew"
        brew install helm

        message "oc" "Install stern (Multi pod and container log tailing for Kubernetes) from brew"
        brew install stern

        message "oc" "Install stern (Tools for observing Kubernetes resources in real time) from brew"
        brew install kubespy
}

oc-install() {
        message "oc" "Install openshift-cli from brew"
        brew install openshift-cli
}


main() {
        kube-install
        kubeval-upstall
        oc-install
}
