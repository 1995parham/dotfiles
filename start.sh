#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : start.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

# global variable that points to dotfiles root directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/scripts/lib/proxy.sh
source $current_dir/scripts/lib/message.sh

# start.sh
program_name=$0

# global variable indicates using parham-usvs proxy in specific script
have_proxy=false

# global variabe indicates force in specific script
force=false

trap '_end' INT

_end() {
        echo "See you later :) [you signal start.sh execuation]"
        exit
}

_usage() {
	echo "usage: $program_name [-p] [-h] script"
	echo "  -p   use parham-usvs proxy"
	echo "  -h   display help"
        echo "  -f   force"
}

_main() {
        local show_help
        local script
        local start
        local took

        show_help=0

        while getopts 'phf' argv; do
                case $argv in
                        h)
                                show_help=1
                                ;;
                        p)
                                have_proxy=true
                                ;;
                        f)
                                force=true
                                ;;
                esac
        done

        for i in $(seq 2 1 $OPTIND 2> /dev/null); do
                shift
        done

        if [ -z $1 ]; then
                _usage
                exit
        fi
        script=$1
        shift

        start=$(date +'%s')

        source $current_dir/scripts/$script.sh 2> /dev/null || { echo "script not found"; exit; }
        if [ "$show_help" -eq "1" ]; then
                usage
        else
                main $@
        fi

        echo
        took=$(( $(date +'%s') - $start ))
        printf "Done. Took %ds.\n" $took
}

if [[ $EUID -eq 0 ]]; then
        message "pre" "it must run without the root permissions with a regular user."
        if [ $force = false ]; then
	        exit 1
        fi
fi

_main $@
