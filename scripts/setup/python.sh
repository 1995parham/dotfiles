#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : python.sh
#
# [] Creation Date : 19-06-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
if hash pip3 2>/dev/null; then
	sudo easy_install3 flake8
	sudo easy_install3 pep8-naming
else
	echo "Please install Python-PIP first."
fi
