#!/bin/bash

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

	msg '1995parham cluster'
	kind create cluster --config "$root/kind/cluster.yaml" --name 1995parham
	msg 'networking with calico'
	kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

	msg 'happy k8s in docker'
}
