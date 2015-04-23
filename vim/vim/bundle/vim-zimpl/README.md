VIM-ZIMPL
=========

# Introduction
Simple syntax highlighting for zimpl written just for fun ....
so it may have many problems ... :-))  

At this moment it can handle almost everything documented zimpl manual

# What does it look like?
![screenshot here..](http://www.googledrive.com/host/0B33KzMHyLoH2eVNHWFJZdmthOVk/vim-zimpl-screenshot.jpg)

# Installation

This project can either be installed manually or by using pathogen.

## Manual Installation

Download syntax/zimpl.vim and copy the file to .vim/syntax/ in your home folder. 
Download ftdetect/zimpl.vim and copy the file to .vim/ftdetect/ in your home folder. 

## Installation with Git & Pathogen

- Install [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) into `~/.vim/autoload/` and add the
   following line to your `~/.vimrc`:

        call pathogen#infect()

- Make a clone of the `vim-zimpl` repository:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle
        $ git clone https://github.com/1995parham/vim-zimpl

- OR use git submodules:

        $ git submodule add https://github.com/1995parham/vim-zimpl.git bundle/vim-zimpl
        $ git submodule init

