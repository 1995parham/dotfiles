#!/bin/bash

usage() {
	echo -n -e "conda for machine learning"

	# shellcheck disable=1004,2016
	echo '
                     _
  ___ ___  _ __   __| | __ _
 / __/ _ \| |_ \ / _` |/ _` |
| (_| (_) | | | | (_| | (_| |
 \___\___/|_| |_|\__,_|\__,_|

  '
}

main_pacman() {
	return 0
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

install-miniconda() {
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

	bash "$HOME/miniconda3/miniconda.sh" -b -u -p "$HOME/miniconda3"
	rm "$HOME/miniconda3/miniconda.sh"
}

main() {
	if [ ! -d "$HOME/miniconda3" ]; then
		mkdir -p "$HOME/miniconda3"
		install-miniconda
	else
		if yes_or_no "conda" "do you want to remove miniconda?"; then
			install-miniconda
		fi
	fi

	msg 'there is a proxy on conda, be careful'

	dotfile conda condarc

	msg 'configuring ipython'

	dotfiles_root=${dotfiles_root:?"dotfiles_root must be set"}

	"$HOME/miniconda3/bin/conda" install ipython

	mkdir -p "$HOME/.ipython/profile_default"
	linker "python" "$dotfiles_root/python/ipython/ipython_config.py" "$HOME/.ipython/profile_default/ipython_config.py"
}
