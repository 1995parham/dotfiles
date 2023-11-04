#!/usr/bin/env bash

packages=(
	flake8
	pep8-naming
	pipenv
	poetry
	hatch
	pdm
	black
)

usage() {
	echo -n "python with useful tools for science and phd"
	# shellcheck disable=1004
	echo '
             _   _
 _ __  _   _| |_| |__   ___  _ __
| |_ \| | | | __| |_ \ / _ \| |_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/

  '
}

main_apt() {
	return 0
}

main_brew() {
	require_brew python@3.11 pipx
}

main_pacman() {
	require_pacman python python-pip python-pipx pyenv

	msg 'GDAL is a translator library for raster and vector geospatial data formats'
	require_pacman gdal

	msg 'MySQL/MariaDB client library'
	require_pacman mariadb-clients

	# msg "update user-local version of pip"
	# python -mpip install --user --pre -U pip
}

python-install-packages() {
	msg "install user-local packages"
	msg "these package generally are there for dependency management"

	for package in "${packages[@]}"; do
		require_pip "$package"
	done
}

main() {
	msg 'a modern python package and dependency manager supporting the latest pep standards'
	configfile pdm "" python

	if yes_or_no "python" "do you want to use v2ray as a python-pip proxy?"; then
		msg 'python pypi start dropping iran traffic, so we need to use a proxy'
		configfile pip "" python
	fi

	python-install-packages

	msg 'pyenv already configured in zsh (zshrc.shared)'
}

main_parham() {
	msg 'setting pypi token on poetry'
	poetry config pypi-token.pypi "$(gopass show -o token/pypi/publish)"
}
