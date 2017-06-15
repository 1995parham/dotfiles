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

cat "$current_dir/logo.txt"

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
# parameter 4 [default = ""]: file name extention - string
dotfile() {
	local module=$1

	for file in "${!2}"; do
		linker $module $file $3 $4
	done
}

# linker
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3 [default = true]: is hidden file - bool
# parameter 4 [default = ""]: file name extention - string
linker() {
	local module=$1
	local file=$2
	local is_hidden=${3:-true}
	local extention=${4:-""}

	if $is_hidden; then
		local dst_file=".$file"
	else
		local dst_file="$file"
	fi
	if [ ! -z $extention ]; then
		local src_file="$file-$extention"
	else
		local src_file="$file"
	fi

	local dst_path="$HOME/$dst_file"
	local src_path="$current_dir/$module/$src_file"

	local create_link=true

	if [ -e $dst_path ] || [ -h $dst_path ]; then
		echo "[$module] $src_file already existed"
		read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm; echo
		if [[ $delete_confirm == "Y" ]]; then
			rm -R $dst_path
			echo "[$module] $dst_path was removed successfully"
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
echo "[vim] Installation begin"; echo
case $install_type in
	0)
		files=("vimrc" "vim")
		dotfile "vim" files[@]
		;;
	1)
		files=("vimrc")
		dotfile "vim" files[@] true "minor"
		files=("vim")
		dotfile "vim" files[@]
		;;
esac
echo "[vim] Installing vim plugins"
vim_log=$(mktemp)
vim -c 'PlugInstall' -c "w $vim_log" -c 'q' -c 'q'
less $vim_log
rm $vim_log
echo; echo "[vim] Installation end"; echo

#### Conf ####
echo "[conf] Installation begin"; echo
case $install_type in
	0)
		files=("dircolors" "wakatime.cfg" "tmux.conf" "pinerc"
			"signature" "copyrighter" "aria2" "tmux" "gdbinit"
			"ctags" "octaverc")
		dotfile "conf" files[@]
		;;
	1)
		files=("bashrc" "dircolors" "tmux.conf" "tmux" "wakatime.cfg")
		dotfile "conf" files[@]
		;;
esac
echo "[conf] Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

echo; echo "[conf] Installation end"; echo

### ZSH ###
echo "[zsh] Installation begin"; echo
case $install_type in
	0)
		files=("zshrc" "zsh.plug")
		dotfile "zsh" files[@]
		;;
esac
echo; echo "[zsh] Installation end"; echo

#### Git ####
echo "[git] Installation begin"; echo
files=("gitconfig" "gitignore")
dotfile "git" files[@]
echo; echo "[git] Installation end"; echo

#### Bin ####
echo "[bin] Installation begin"; echo
files=("bin")
dotfile "bin" files[@] false
echo; echo "[bin] Installation end"; echo

#### General configuration ####
echo "[general configuration] Let's configure the things !"; echo
case $install_type in
	0)
		if [ $SHELL != '/bin/zsh' ]; then
			chsh $USER -s /bin/zsh
		fi
		;;
	1)
		;;
esac
echo "[general configuration] We are done here !"; echo

echo "[post] Thank you for using Parham Alvani dotfiles ! :)"
echo -e "[post] Please check following directories:\n1. fonts/\n2. scripts/"
echo "[post] Use *r* for reload your zshrc in place"
