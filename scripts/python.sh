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
	mypy
	black
	'python-language-server[all]'
	pyls-mypy
	pylint
	poetry

	pynvim
)

usage() {
	echo -n "python with pyenv to use every version with ease"
}

main_brew() {
	brew install pyenv
}

main_apt() {
	msg "apt doesn't have pyenv so we need to install it manually"
	curl https://pyenv.run | bash || true

	export PATH="$HOME/.pyenv/bin:$PATH"
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"

	msg "please use the followin settings on .profile"
	echo '
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
	'
}

main_pacman() {
	sudo pacman -Syu --needed --noconfirm pyenv
}

python-install-package() {
	if python3 -mpip install -U "$1"; then
		msg "$1 installation succeeded"
	else
		msg "$1 installation failed"
	fi
}

python-install-packages() {
	message "python" "Fetch some good and useful python packages"

	message "python" "Python Tools"

	printf "%s\n" "${packages[@]}" >"$(pyenv root)/default-packages"
	for package in "${packages[@]}"; do
		python-install-package "$package"
	done
}

main() {
	if [[ "$(command -v pyenv)" ]]; then
		git clone https://github.com/jawshooah/pyenv-default-packages.git "$(pyenv root)/plugins/pyenv-default-packages" || echo "pyenv-default-packages is already installed"
		pyenv versions
	fi

	read -r -p "[python] do you want to install useful packages ?[Y/n] " -n 1 confirm
	echo

	if [[ $confirm == "Y" ]]; then
		python-install-packages
	fi
}
