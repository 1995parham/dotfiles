#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -e

# global variable that points to dotfiles root directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/scripts/lib/message.sh
source $current_dir/scripts/lib/proxy.sh

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

# Creates a config file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configrootfile() {
        local module=$1
        local src_file=$2
        local src_dir=$3

        if [ ! -e "$HOME/.config" ]; then
                mkdir "$HOME/.config"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
                local dst_file="$src_file"
        fi
        local dst_path="$HOME/.config/$dst_file"

        linker $module $src_path $dst_path
}

# Creates a systemd file that resides in the `.config` directory, and provides a soft link for it.
# for better organization of the repository, modules can be gathered into a directory, in these cases
# the third parameter is used.
# parameter 1: module name - string
# parameter 2: file name - string
# parameter 3: directory - string - optional
configsystemd() {
        local module=$1
        local src_file=$2
        local src_dir=$3

        if [ ! -e "$HOME/.config/systemd/user" ]; then
                mkdir -p "$HOME/.config/systemd/user"
        fi

        if [ ! -z $src_file ]; then
                local src_path="$current_dir${src_dir:+/$src_dir}/$module/$src_file"
                local dst_file="$src_file"
        fi
        local dst_path="$HOME/.config/systemd/user/$dst_file"

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

                read -p "[$module] do you want to remove $dst_path ?[Y/n] " -n 1 delete_confirm; echo

                if [[ $delete_confirm == "Y" ]]; then
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

# start.sh
program_name=$0

trap '_end' INT

_end() {
        echo "See you later :) [you signal start.sh execuation]"
        exit
}

_usage() {
	echo "usage: $program_name [-p] [-h] [-f] script [script options]"
	echo "  -p   use parham-usvs proxy"
	echo "  -h   display help"
        echo "  -f   force"
}

_main() {
        ## global variables ##

        # global variable indicates force in specific script
        local force=false

        # global variable indicates show help for user in specific script
        # there is no need to use it in your script
        local show_help=false


        # parses options flags
        while getopts 'hf' argv; do
                case $argv in
                        h)
                                show_help=true
                                ;;
                        f)
                                force=true
                                ;;
                esac
        done

        for ((i=2; i<=OPTIND; i++)); do
                shift
        done

        # handles root user
        if [[ $EUID -eq 0 ]]; then
                message "pre" "it must run without the root permissions with a regular user."
                if [ $force = false ]; then
	                exit 1
                fi
                message "pre" "I hope you know what you are doing by using -f."
        fi

        # handles given script run and result
        local script
        local start
        local took

        if [ -z $1 ]; then
                _usage
                exit
        fi
        script=$1
        shift

        start=$(date +'%s')

        source $current_dir/scripts/$script.sh 2> /dev/null || { echo "404 script not found"; exit; }
        if [ $show_help = true ]; then
                # prints the start.sh and the script helps
                _usage
                echo
                usage
        else
                # run the script
                main $@
        fi

        echo
        took=$(( $(date +'%s') - start ))
        printf "Done. Took %ds.\n" $took
}

_main $@
