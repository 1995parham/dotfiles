#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : over-the-air-installation.sh
#
# [] Creation Date : 13-09-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
if ! [ -x "$(command -v git)" ]; then
	echo "git is not installed. please install it first"
	exit 1
fi

echo "create directory structure"
mkdir "$HOME/Documents"
mkdir "$HOME/Downloads"
mkdir -p "$HOME/Documents/Git/$USER"
mkdir -p "$HOME/Documents/Git/others"

echo "clone https://github.com/1995parham/dotfiles"
cd "$HOME/Documents/Git/$USER" || exit
git clone https://github.com/1995parham/dotfiles
cd dotfiles || exit

echo "please refer to readme for further information"
