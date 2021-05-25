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

main() {
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
	bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm ~/miniconda3/miniconda.sh
}
