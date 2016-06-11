#!/bin/
# In The Name Of God
# ========================================
# [] File Name : install.node.sh
#
# [] Creation Date : 11-06-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [ "$OSTYPE" == "darwin"* ]; then
	brew install node
else
	curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
	sudo apt install -y nodejs
fi
