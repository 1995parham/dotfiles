#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : install.sh
#
# [] Creation Date : 09-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "[pre] Home directory found at $HOME"

echo "[pre] Current directory found at $current_dir"

# Dotfile
# parameter 1: module name - string
# parameter 2: file names - array of string
dotfile() {
	module=$1

	for file in "${!2}"; do
		linker $module $file
	done
}

# linker
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3 [default = false]: is hidden file - bool
linker() {
	module=$1
	file=$2
	is_hidden=true

	dst_file=".$file"
	src_file=file

	dst_path="$HOME/$dst_file"
	src_path="$current_dir/$module/$file"

	create_link=true

	if [ -e $dst_path ] || [ -h $dst_path ]; then
		echo "[$module] $src_file already existed"
		read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm; echo
		echo $delete_confirm
		if [[ $delete_confirm == "Y" ]]; then
			rm -R $dst_path
			"[$module] $dst_path was removed successfully"
		else
			create_link=false
		fi
	fi

	if $create_link; then
		ln -s $src_path $dst_path
		echo "[$module] Symbolic link created successfully from $src_path to $dst_path"
	fi
}

#### VIM ####
files=("vimrc" "vim")
dotfile "vim" files[@]
