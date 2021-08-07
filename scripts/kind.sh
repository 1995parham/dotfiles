#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : kind.sh
#
# [] Creation Date : 27-07-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
	echo -n "kubernetes in docker"

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
	msg "there is nothing that we can do"
	return 1
}

main_pacman() {
	yay -Syu kind-bin
}

main_brew() {
	msg "there is nothing that we can do"
	return 1
}

main() {
	current_dir=${current_dir:?"current_dir must be set"}

	msg '1995parham cluster'
	kind create cluster --config "$current_dir/kind/cluster.yaml" --name 1995parham
	msg 'networking with calico'
	kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

	msg 'happy k8s in docker'
}
