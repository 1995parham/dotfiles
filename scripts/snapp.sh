#!/bin/
# In The Name of God
# ========================================
# [] File Name : sample.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: snapp"
        echo "install snapp corporation mail/calender/contacts"
}

# Creates a config file that resides in the `.config` directory, and provides a soft link for it.
# parameter 1: module name - string
# parameter 2: file name - string
configfile() {
        local module=$1
        local src_file=$2

        if [ ! -e "$HOME/.config" ]; then
                mkdir "$HOME/.config"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir/snapp/$module/$src_file"
                local dst_file="$module/$src_file"

                if [ ! -d "$HOME/.config/$module" ]; then
                        mkdir "$HOME/.config/$module"
                fi
        else
                src_file=$module
                local src_path="$current_dir/snapp/$module"
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

main() {
        # Reset optind between calls to getopts
        OPTIND=1

	sudo pacman -Syu --noconfirm --needed mutt vdirsyncer khal
        yay davmail

        systemctl --user enable davmail@snapp
        systemctl --user start davmail@snapp

        configfile davmail
        configfile khal
        configfile vdirsyncer
        configfile mutt
}
