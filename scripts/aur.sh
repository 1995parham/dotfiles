#!/bin/bash

usage() {
	echo -n "1995parham's aur packages"

	echo '
  __ _ _   _ _ __
 / _| | | | | |__|
| (_| | |_| | |
 \__,_|\__,_|_|
'
}

main() {
	mkdir -p "$HOME/Documents/Git/parham/aur"

	pkgs=(
		"natscli"
		"natscli-bin"
		"okd-client-bin"
		"gosimac-bin"
		"dive-bin"
		"actionlint-bin"
		"jcal"
		"mprocs-bin"
		"mprocs"
		#		"litmusctl-bin"
	)

	for pkg in "${pkgs[@]}"; do
		if [ ! -d "$HOME/Documents/Git/parham/aur/$pkg" ]; then
			git clone "aur@aur.archlinux.org:$pkg" "$HOME/Documents/Git/parham/aur/$pkg"
		else
			echo "$pkg is already exists"
		fi
	done
}
