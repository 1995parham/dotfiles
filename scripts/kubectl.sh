#!/bin/bash

export dependencies=('go')

usage() {
	echo "k8s and openshift command line tools (kubectl, oc, stern, kubeval, etc.)"
	# shellcheck disable=2028
	echo '
 _          _               _   _
| | ___   _| |__   ___  ___| |_| |
| |/ / | | | |_ \ / _ \/ __| __| |
|   <| |_| | |_) |  __/ (__| |_| |
|_|\_\\__,_|_.__/ \___|\___|\__|_|

	'
}

main_brew() {
	require_brew kubernetes-cli helm stern argocd openshift-cli kubectx
}

main_pacman() {
	require_pacman kubectl helm argocd kubectx stern k9s

	require_aur kubeval-bin okd-client-bin kube-score-bin
}

main() {
	msg 'install helm-ls on neovim'
	require_mason 'helm-ls'

	msg "awesome chart repositories for helm"
	# Bitnami has migrated into OCI registry, which can be used directly.
	# helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo add nats https://nats-io.github.io/k8s/helm/charts || true
	helm repo add pyroscope-io https://pyroscope-io.github.io/helm-chart || true
	helm repo add benthos https://benthosdev.github.io/benthos-helm-chart || true
	helm repo add emqx https://repos.emqx.io/charts || true

	helm repo update
}
