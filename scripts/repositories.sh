#!/bin/bash

usage() {
	echo -n "Repositories at your service"
	# shellcheck disable=2016
	echo '
                          _ _             _
 _ __ ___ _ __   ___  ___(_) |_ ___  _ __(_) ___  ___
| |__/ _ \ |_ \ / _ \/ __| | __/ _ \| |__| |/ _ \/ __|
| | |  __/ |_) | (_) \__ \ | || (_) | |  | |  __/\__ \
|_|  \___| .__/ \___/|___/_|\__\___/|_|  |_|\___||___/
         |_|
	'
}

function group() {
	echo ""
	running git "$*"
	echo ""
}

from_github() {
	label=$1
	repo=$2

	path="$HOME/Documents/Git/others/$label/${repo%/*}"

	clone "git@github.com:$repo" "$path"
}

group_learning() {
	group "learn new things from github"

	from_github "learning" "rlabbe/Kalman-and-Bayesian-Filters-in-Python"
	from_github "learning" 'teivah/100-go-mistakes'
}

group_nice_to_have() {
	group "good to have these projects from github"

	from_github "helm" "nats-io/k8s"
}

main_pacman() {
	return 0
}

main_brew() {
	return 0
}

main() {
	group_learning
	group_nice_to_have
}
