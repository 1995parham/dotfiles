#!/bin/bash
#
# In The Name Of God
# ========================================
# [] File Name : update.bash
#
# [] Creation Date : 01-02-2015
#
# [] Last Modified : Mon 09 Mar 2015 01:39:55 AM IRST
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

# update sqlite file
if [ -e $HOME/.sqliterc ]; then
	echo "cp $HOME/.sqliterc sqliterc"
	cp $HOME/.sqliterc sqliterc
fi


# update vim folder
if [ -d $HOME/.vim ]; then
	echo "rm -Rf Vim"
	rm -Rf Vim
	echo "cp -Ru $HOME/.vim Vim"
	cp -R $HOME/.vim Vim
fi
