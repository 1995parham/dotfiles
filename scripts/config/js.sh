#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : js.sh
#
# [] Creation Date : 19-06-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if hash npm 2>/dev/null; then
	sudo npm install -g eslint
	sudo npm install -g eslint-plugin-standard
	sudo npm install -g eslint-config-standard
else
	echo "Please install NodeJS [node, npm, ..] first."
fi
