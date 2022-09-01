#!/bin/bash

export dependencies=('go')

usage() {
	echo "k8s and openshift command line tools (kubectl, oc, stern, kubeval, etc.)"
	echo '
 _          _               _   _
| | ___   _| |__   ___  ___| |_| |
| |/ / | | | |_ \ / _ \/ __| __| |
|   <| |_| | |_) |  __/ (__| |_| |
|_|\_\\__,_|_.__/ \___|\___|\__|_|

	'
}

main_brew() {
	brew install kubernetes-cli

	brew install helm

	brew install stern

	brew install argocd

	brew install openshift-cli

	brew install kubectx
}

main_pacman() {
	require_pacman kubectl helm argocd kubectx

	require_aur stern-bin kubeval-bin okd-client-bin kube-score-bin

	# msg "Command-Line tool to manage Litmuschaos's agent plane"
	# yay -Syu --noconfirm --needed litmusctl
}

main() {
	msg "awesome chart repositories for helm"
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo add nats https://nats-io.github.io/k8s/helm/charts || true
	helm repo add pyroscope-io https://pyroscope-io.github.io/helm-chart || true
	helm repo add benthos https://benthosdev.github.io/benthos-helm-chart || true

	helm repo update
}
