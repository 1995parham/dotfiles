#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : install.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Sun Feb  1 01:46:10 2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

# install vimrc file
if [ -e $HOME/.vimrc ]; then
	echo "cp vimrc $HOME/.vimrc"
	cp vimrc $HOME/.vimrc
fi

# install zshrc file
if [ -e $HOME/.zshrc ]; then
	echo "cp zshrc $HOME/.zshrc"
	cp zshrc $HOME/.zshrc
fi

# install gdbinit file
if [ -e $HOME/.gdbinit ]; then
	echo "cp gdbinit $HOME/.gdbinit"
	cp gdbinit $HOME/.gdbinit
fi

# install pinerc file
if [ -e $HOME/.pinerc ]; then
	echo "cp pinerc $HOME/.pinerc"
	cp pinerc $HOME/.pinerc
fi

# install vim folder
if [ -d $HOME/.vim ]; then
	echo "rm -Rf $HOME/.vim"
	rm -Rf $HOME/.vim
	echo "cp -R Vim $HOME/.vim"
	cp -R Vim $HOME/.vim
fi
