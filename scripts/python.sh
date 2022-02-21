#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

packages=(
	flake8
	pep8-naming
	pipenv
	poetry
	mypy
	black
	'python-language-server[all]'
	pyls-mypy
	pylint
	poetry
	'isort[pipfile_deprecated_finder]'
	ipython
	numpy
	matplotlib
	pandas

	pynvim
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

main_brew() {
	return 0
}

main_apt() {
	return 0
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm python python-pip
	# update pip to work with python 3.10
	sudo python -mpip install -U pip
}

python-install-package() {
	if python3 -mpip install -U "$1"; then
		msg "$1 installation succeeded"
	else
		msg "$1 installation failed"
	fi
}

python-install-packages() {
	message "python" "fetch some good and useful python packages"

	for package in "${packages[@]}"; do
		python-install-package "$package"
	done
}

main() {
	python-install-packages
}
