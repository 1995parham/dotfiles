#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : update.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Sun Feb  1 01:48:37 2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

# update vimrc file
if [ -e $HOME/.vimrc ]; then
	echo "cp $HOME/.vimrc vimrc"
	cp $HOME/.vimrc vimrc
fi

# update zshrc file
if [ -e $HOME/.zshrc ]; then
	echo "cp $HOME/.zshrc zshrc"
	cp $HOME/.zshrc zshrc
fi

# update gdbinit file
if [ -e $HOME/.gdbinit ]; then
	echo "cp $HOME/.gdbinit gdbinit"
	cp $HOME/.gdbinit gdbinit
fi

# update pinerc file
if [ -e $HOME/.pinerc ]; then
	echo "cp $HOME/.pinerc pinerc"
	cp $HOME/.pinerc pinerc
fi

# update vim folder
if [ -d $HOME/.vim ]; then
	echo "rm -Rf Vim"
	rm -Rf Vim
	echo "cp -Ru $HOME/.vim Vim"
	cp -R $HOME/.vim Vim
fi
