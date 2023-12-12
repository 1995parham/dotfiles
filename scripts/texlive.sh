#!/usr/bin/env bash

usage() {
	echo -n "install texlive with ease without any package manager"
	# shellcheck disable=1004
	echo '
 _            _ _
| |_ _____  _| (_)_   _____
| __/ _ \ \/ / | \ \ / / _ \
| ||  __/>  <| | |\ V /  __/
 \__\___/_/\_\_|_| \_/ \___|

	'
}

main_pacman() {
	require_pacman texlab python-pygments graphviz tectonic
	require_aur libxcrypt-compat
}

main_brew() {
	require_brew tectonic latexindent texlab
}
