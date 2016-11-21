#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : tmux.sh
#
# [] Creation Date : 17-03-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[tmux] This script must be run as root"
	exit 1
fi

echo "[tmux] Installing tmux 2.x"

if [ "$OSTYPE" == "darwin"* ]; then
	brew install tmux
else
	if [ `lsb_release -s -d | gawk -F " " '{print $2}' | gawk -F "." '{print $1}'` -lt 15 ]; then
		echo "Installing tmux on old ubuntu [before 15.05]"
		apt-get update
		apt-get install -y python-software-properties software-properties-common
		add-apt-repository -y ppa:pi-rho/dev
		apt-get update
		apt-get install -y tmux
	else
		echo "Installing tmux on new ubuntu [15.05 and after]"
		sudo apt-get install tmux
	fi
fi
