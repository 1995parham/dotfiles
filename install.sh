#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : install.sh
#
# [] Creation Date : 09-07-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
set -e
program_name=$0

usage() {
	echo "usage: $program_name [-h] [-y]"
	echo "  -y   yes to all"
	echo "  -h   display help"
}

# global variable that points to dotfiles root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cat "$current_dir/logo.txt"
echo
source "$current_dir/scripts/lib/message.sh"
source "$current_dir/scripts/lib/linker.sh"

message "pre" "Home directory found at $HOME"

message "pre" "Current directory found at $current_dir"

yes_to_all=0
while getopts "hy" argv; do
	case $argv in
	y)
		yes_to_all=1
		;;
	h)
		usage
		exit
		;;
	esac
done

requirements=(zsh tmux vim nvim)

# check the existence of required softwares
for cmd in ${requirements[@]}; do
	if ! hash $cmd 2>/dev/null; then
		message "pre" "Please install $cmd before using this script"
		exit 1
	fi
done

# vim
install-vim() {
	files=("vim" "vimrc")
	dotfile "vim" files[@]

	message "vim" "Installing vim plugins"
	vim +PlugInstall +qall
}

# nvim
install-nvim() {
	configfile "nvim"
	message "nvim" "Installing neovim plugins"
	nvim --headless +PlugInstall +qall
}

# configurations
install-conf() {
	files=("dircolors" "wakatime.cfg" "tmux.conf" "tmux" "aria2")
	dotfile "conf" files[@]
	configfile "htop" "" "conf"

	message "conf" "Installing tmux plugins"
	~/.tmux/plugins/tpm/bin/install_plugins
}

# zsh
install-zsh() {
	files=("zshrc" "zsh.plug")
	dotfile "zsh" files[@]
}

# git
install-git() {
	configfile "git"
}

# bin
install-bin() {
	files=("bin")
	dotfile "bin" files[@] false
}

# general
install-general() {
	if [ $SHELL != '/bin/zsh' ]; then
		message "general" "Please change your shell to zsh manually"
	fi
}

# calls each module install function.
modules=(vim nvim conf zsh git bin general)
for module in ${modules[@]}; do
	message $module "Installation begin"
	echo
	install-$module
	echo
	message $module "Installation end"
	echo
done

announce "post" "Thank you for using Parham Alvani dotfiles ! :)"
announce "post" "Use *r* for reload your zshrc in place"
