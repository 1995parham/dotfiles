#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 15-08-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [ "$OSTYPE" == "darwin"* ]; then
	wget https://www.python.org/ftp/python/3.5.2/python-3.5.2-macosx10.6.pkg
	echo 'PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.5/bin/"' >> ~/.zshrc.local

else
	sudo apt install python3 python3-venv python3-pip
fi
