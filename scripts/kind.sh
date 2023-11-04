#!/usr/bin/env bash

usage() {
	echo -n "kubernetes in docker and maybe podman?"

	# shellcheck disable=1004,2016
	echo '
 _    _           _
| | _(_)_ __   __| |
| |/ / | |_ \ / _| |
|   <| | | | | (_| |
|_|\_\_|_| |_|\__,_|
  '
}

export dependencies=("kubectl")

main_apt() {
	return 1
}

main_pacman() {
	require_aur kind
}

main_brew() {
	return 1
}

main() {
	root=${root:?"root must be set"}

	msg 'create 1995parham cluster (delete if it exists) and set the kubeconfig'
	kind delete cluster --name 1995parham || true
	kind create cluster --config "$root/kind/cluster.yaml" --name 1995parham
	msg 'ingress using contour'
	kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
	msg 'networking with calico'
	kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

	msg 'happy k8s in docker'
}
