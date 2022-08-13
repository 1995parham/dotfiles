#!/bin/bash

usage() {
	echo -n "aur's packages maintain by 1995parham"

	echo '
  __ _ _   _ _ __
 / _| | | | | |__|
| (_| | |_| | |
 \__,_|\__,_|_|

  '
}

main_pacman() {
	return 0
}

main() {
	mkdir -p "$HOME/Documents/Git/parham/aur"

	pkgs=(
		"natscli"
		"natscli-bin"
		"okd-client-bin"
		"gosimac-bin"
		"gosimac"
		"dive-bin"
		"actionlint-bin"
		"jcal"
		"mprocs-bin"
		"mprocs"
		"gotz"
		"scitopdf-git"
		"jira-cli"
		#		"litmusctl-bin"
	)

	for pkg in "${pkgs[@]}"; do
		if [ ! -d "$HOME/Documents/Git/parham/aur/$pkg" ]; then
			git clone "aur@aur.archlinux.org:$pkg" "$HOME/Documents/Git/parham/aur/$pkg"
		else
			msg "$pkg is already exists"
		fi
	done
}
