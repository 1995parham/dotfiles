#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : install-tmux.sh
#
# [] Creation Date : 17-03-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [ "$OSTYPE" == "darwin"* ]; then
	brew install tmux
else
	if [ `lsb_release -s -d | gawk -F " " '{print $2}' | gawk -F "." '{print $1}'` -lt 15 ]; then
		echo "Installing tmux on old ubuntu [before 15.05]"
		sudo apt-get update
		sudo apt-get install -y python-software-properties software-properties-common
		sudo add-apt-repository -y ppa:pi-rho/dev
		sudo apt-get update
		sudo apt-get install -y tmux
	else
		echo "Installing tmux on new ubuntu [15.05 and after]"
		sudo apt-get install tmux
	fi
fi
