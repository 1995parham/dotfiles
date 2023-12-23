#!/usr/bin/env bash

usage() {
	echo -n "Tectonic is a modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive."
	# shellcheck disable=1004
	echo '
 _____         _              _
|_   _|__  ___| |_ ___  _ __ (_) ___
  | |/ _ \/ __| __/ _ \| |_ \| |/ __|
  | |  __/ (__| || (_) | | | | | (__
  |_|\___|\___|\__\___/|_| |_|_|\___|

	'
}

main_pacman() {
	require_pacman texlab python-pygments graphviz tectonic
	require_aur libxcrypt-compat
}

main_brew() {
	require_brew tectonic latexindent texlab
}
