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

osPS3=$PS3
PS3="[pre] Please choose a type [ENTER to list options]:"
install_type=0
select t in "Default" "Minor"; do
	if [ ! -z "$t" ]; then
		case $REPLY in
			1)
				install_type=0
				break
				;;
			2)
				install_type=1
				break
				;;
		esac
	else
		echo "$REPLY in not a valid option"
	fi
done
PS3=$oPS3

# Dotfile
# parameter 1: module name - string
# parameter 2: file names - array of string
# parameter 3 [default = true]: is hidden file - bool
dotfile() {
	module=$1

	for file in "${!2}"; do
		linker $module $file
	done
}

# linker
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3 [default = true]: is hidden file - bool
linker() {
	module=$1
	file=$2
	is_hidden=${3:-true}

	if [ $is_hidden ]; then
		dst_file=".$file"
	else
		dst_file="$file"
	fi
	src_file=file

	dst_path="$HOME/$dst_file"
	src_path="$current_dir/$module/$file"

	create_link=true

	if [ -e $dst_path ] || [ -h $dst_path ]; then
		echo "[$module] $src_file already existed"
		read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm; echo
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
