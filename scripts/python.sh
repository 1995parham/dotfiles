#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 22-11-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if [[ $EUID -ne 0 ]]; then
	echo "[python] This script must be run as root"
	exit 1
fi

echo "[python] Installing Python 3.x"

if [ "$OSTYPE" == "darwin"* ]; then
	wget https://www.python.org/ftp/python/3.5.2/python-3.5.2-macosx10.6.pkg
	echo 'PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.5/bin/"' >> ~/.zshrc.local

else
	apt-get install python3 python3-venv python3-pip
fi

echo "[python] Installing flake-8 pep8-naming sphinx"

easy_install3 flake8
easy_install3 pep8-naming
easy_install3 sphinx
