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
tput clear # Clear screen and move the cursor to 0,0
program_name=$0

usage() {
        echo "usage: $program_name [-m] [-h] [-y]"
        echo "  -y   yes to all"
        echo "  -m   minor version"
        echo "  -h   display help"
}

# global variable that points to dotfiles root directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat "$current_dir/logo.txt"
echo
source "$current_dir/scripts/lib/message.sh"

message "pre" "Home directory found at $HOME"

message "pre" "Current directory found at $current_dir"

install_type=0
yes_to_all=0
while getopts "mhy" argv; do
        case $argv in
                m)
                        install_type=1
                        ;;
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
case $install_type in
        0)
                message "pre" "Default installation"
                ;;
        1)
                message "pre" "Headless installation"
                ;;
esac
echo

# check the existence of required softwares
for cmd in ${requirements[@]}; do
        if ! hash $cmd 2>/dev/null; then
                message "pre" "Please install $cmd before using this script"
                exit 1
        fi
done

# Creates a config file that resides in the `home` directory, and provides a soft link to it.
# parameter 1: module name - string
# parameter 2: file names - array of string
# parameter 3 [default = true]: is hidden file - bool
dotfile() {
        local module=$1
        local files=${!2}
        local is_hidden=${3:-true}

        for file in $files; do
                if $is_hidden; then
                        local dst_file=".$file"
                else
                        local dst_file="$file"
                fi

                local src_file="$file"

                local dst_path="$HOME/$dst_file"
                local src_path="$current_dir/$module/$src_file"

                linker $module $src_path $dst_path
        done
}

# Creates a config file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string - optional
# parameter 3: directory - string - optional
configfile() {
        local module=$1
        local src_file=$2
        local src_dir=$3

        if [ ! -e "$HOME/.config" ]; then
                mkdir "$HOME/.config"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
                local dst_file="$module/$src_file"

                if [ ! -d "$HOME/.config/$module" ]; then
                        mkdir "$HOME/.config/$module"
                fi
        else
                src_file=$module
                local src_path="$current_dir${src_dir:+/$src_dir}/$module"
                local dst_file="$module"
        fi
        local dst_path="$HOME/.config/$dst_file"

        linker $module $src_path $dst_path
}

# linker
# parameter 1: module name - string
# parameter 2: source path - string
# parameter 3: destination path - string
linker() {
        local module=$1
        local src_path=$2
        local dst_path=$3

        local create_link=true

        if [ -e $dst_path ] || [ -L $dst_path ]; then
                message "$module" "$dst_path already existed"

                if [[ $src_path = $(readlink $dst_path) ]]; then
                        message "$module" "$dst_path is a correct link"
                        create_link=false
                        return
                fi

                if [[ $yes_to_all == 0 ]]; then
                        read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm; echo
                fi

                if [[ $delete_confirm == "Y" ]] || [[ $yes_to_all == 1 ]]; then
                        rm -R $dst_path
                        message "$module" "$dst_path was removed successfully"
                else
                        create_link=false
                fi
        fi

        if $create_link; then
                ln -s $src_path $dst_path
                message "$module" "Symbolic link created successfully from $src_path to $dst_path"
        fi
}

#### vim ####
install-vim() {
        files=("vim" "vimrc")
        dotfile "vim" files[@]

        message "vim" "Installing vim plugins"
        vim +PlugInstall +qall
}

#### nvim ####
install-nvim() {
        configfile "nvim"
        message "nvim" "Installing neovim plugins"
        nvim --headless +PlugInstall +qall
}

#### configurations ####
install-conf() {
        files=("dircolors" "wakatime.cfg" "tmux.conf" "tmux" "aria2")
        dotfile "conf" files[@]
        configfile "htop" "" "conf"

        message "conf" "Installing tmux plugins"
        ~/.tmux/plugins/tpm/bin/install_plugins
}

### zsh ###
install-zsh() {
        files=("zshrc" "zsh.plug")
        dotfile "zsh" files[@]
}

#### git ####
install-git() {
        configfile "git"
}

#### bin ####
install-bin() {
        files=("bin")
        dotfile "bin" files[@] false
}

#### general ####
install-general() {
        if [ $SHELL != '/bin/zsh' ]; then
                chsh $USER -s /bin/zsh || sudo chsh $USER -s /bin/zsh || message "general" "Please change your shell to zsh manually"
        fi
}

# calls each module install function.
modules=(vim nvim conf zsh git bin general)
for module in ${modules[@]}; do
        message $module "Installation begin"; echo
        install-$module
        echo; message $module "Installation end"; echo
done

announce "post" "Thank you for using Parham Alvani dotfiles ! :)"
announce "post" "Please check following directories:"
announce "post" "1. fonts/ [Meslo LG S Powerline]"
announce "post" "2. scripts/"
announce "post" "Plase use shecan dns: 178.22.122.100"
announce "post" "Use *r* for reload your zshrc in place"
