#!/bin/bash

packages=(
	flake8
	pep8-naming
	pipenv
	poetry
	pdm
	black
	ipython
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
	return 0
}

main_pacman() {
	require_pacman python python-pip

	msg "update user-local version of pip"
	python -mpip install --user --pre -U pip
}

python-install-package() {
	if python -mpip install --user --pre -U "$1"; then
		msg "$1 installation succeeded"
	else
		msg "$1 installation failed"
	fi
}

python-install-packages() {
	msg "install user-local packages"
	msg "these package generally are there for dependency management"

	for package in "${packages[@]}"; do
		python-install-package "$package"
	done
}

main() {
	msg "configuration ipython for having better experience"

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	mkdir -p "$HOME/.ipython/profile_default"
	linker "python" "$dotfiles_root/python/ipython/ipython_config.py" "$HOME/.ipython/profile_default/ipython_config.py"
	configfile pdm "" python

	python-install-packages
}
