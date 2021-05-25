#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : conda.sh
#
# [] Creation Date : 25-05-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

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
		read -r -p "[conda] do you want to remove miniconda?[Y/n] " -n 1 confirm
		echo

		if [[ $confirm == "Y" ]]; then
			install-miniconda
		fi
	fi

	dotfile conda condarc
}
