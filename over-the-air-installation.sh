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
  echo "git is not installed."
  exit 1
fi

echo "Create directory structure"
mkdir $HOME/Documents
mkdir $HOME/Downloads
mkdir -p $HOME/Documents/Git/parham
mkdir -p $HOME/Documents/Git/others

echo "Clone https://github.com/1995parham/dotfiles"
cd $HOME/Documents/Git/parham
git clone https://github.com/1995parham/dotfiles
cd dotfiles

echo "Install the reuired packages using './start.sh env'"
echo 'Add universal package using "sudo add-apt-repository deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"'
echo "Install dotfiles using ./install.sh"
