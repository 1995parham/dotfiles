#!/usr/bin/env bash

usage() {
	echo -n -e "u-mamba for machine learning and data science"

	# shellcheck disable=1004,2016
	echo '
                           _
 _ __ ___   __ _ _ __ ___ | |__   __ _
| |_ | _ \ / _| | |_ | _ \| |_ \ / _| |
| | | | | | (_| | | | | | | |_) | (_| |
|_| |_| |_|\__,_|_| |_| |_|_.__/ \__,_|

  '
}

main_pacman() {
	require_pacman ttf-liberation
	require_aur micromamba-bin
}

main_brew() {
	require_brew micromamba
}

main() {
	dotfile mamba mambarc

	micromamba shell init --shell=zsh --prefix="$HOME/micromamba"
	micromamba install -n base jupyterlab pandas numpy geopandas
}
