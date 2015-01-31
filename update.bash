#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : update.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Sun Feb  1 01:13:31 2015
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

# update vimrc file
if [ -e $HOME/.vimrc ]; then
	cp $HOME/.vimrc vimrc
fi

# update zshrc file
if [ -e $HOME/.zshrc ]; then
	cp $HOME/.zshrc zshrc
fi

# update gdbinit file
if [ -e $HOME/.gdbinit ]; then
	cp $HOME/.gdbinit gdbinit
fi

# update pinerc file
if [ -e $HOME/.pinerc ]; then
	cp $HOME/.pinerc pinerc
fi

# update vim folder
if [ -d $HOME/.vim ]; then
	cp -Ru $HOME/.vim Vim
fi
