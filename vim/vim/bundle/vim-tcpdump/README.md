VIM-TCPDUMP
===========

# Introduction
Simple syntax highlighting for tcpdump output files saved with .tcpd extension
written just for fun .... so it may have many problems ... :-))  

# What does it look like?

# Installation

This project can either be installed manually or by using pathogen.

## Manual Installation

Download syntax/tcpdump.vim and copy the file to .vim/syntax/ in your home folder. 
Download ftdetect/tcpdump.vim and copy the file to .vim/ftdetect/ in your home folder. 

## Installation with Git & Pathogen

- Install [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) into `~/.vim/autoload/` and add the
   following line to your `~/.vimrc`:

        call pathogen#infect()

- Make a clone of the `vim-zimpl` repository:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle
        $ git clone https://github.com/1995parham/vim-tcpdump

- OR use git submodules:

        $ git submodule add https://github.com/1995parham/vim-tcpdump.git bundle/vim-tcpdump
        $ git submodule init

