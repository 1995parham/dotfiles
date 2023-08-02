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
	repo=$1

	path="$HOME/Documents/Git/others/${repo%/*}"

	clone "git@github.com:$repo" "$path"
}

group_learning() {
	group "learn new things from github"

	from_github "rlabbe/Kalman-and-Bayesian-Filters-in-Python"
}

main_pacman() {
	return 0
}

main_brew() {
	return 0
}

main() {
	group_learning
}
