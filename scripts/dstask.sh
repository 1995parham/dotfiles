#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : gopass.sh
#
# [] Creation Date : 05-08-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: dstask"
}


dstask-upstall() {
        message "dstask" "Upstall gppass from github"
        dstask_vr=$(curl -s https://api.github.com/repos/naggie/dstask/releases/latest | grep 'tag_name' | cut -d\" -f4)
        dstask_vl=''
        if hash dstask &> /dev/null; then
                dstask_vl=$(dstask version | grep Version | cut -d' ' -f2)
        fi

        message "dstask" "github: $dstask_vr, local: $dstask_vl"
        if [[ $dstask_vr != $dstask_vl ]]; then
                message "dstask" "Dowloading from github"
                curl -L https://github.com/naggie/dstask/releases/download/${dstask_vr}/dstask-linux-amd64 > dstask
                chmod +x dstask
                sudo mv dstask /usr/local/bin/dstask
        fi

        message "dstask" "$(dstask version)"
}

main() {
        if [[ $OSTYPE == "linux-gnu" ]]; then
                dstask-upstall
        fi

}
