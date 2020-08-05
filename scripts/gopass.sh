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
        echo "usage: gopass"
}


gopass-upstall() {
        message "gopass" "Upstall gppass from github"
        gopass_vr=$(curl -s https://api.github.com/repos/gopasspw/gopass/releases/latest | grep 'tag_name' | cut -d\" -f4)
        gopass_vl=''
        if hash gopass &> /dev/null; then
                gopass_vl=$(gopass version | grep Version | cut -d' ' -f2)
        fi

        if [[ $gopass_vr != $gopass_vl ]]; then
                message "gopass" "Dowloading from github"
                curl -L https://github.com/gopasspw/gopass/releases/download/${gopass_vr}/gopass_${gopass_vr#v}_linux_amd64.deb > gopass.deb
                sudo dpkg -i gopass.deb
                rm gopass.deb
        fi

        message "gopass" "$(gopass version)"
}

main() {
        sudo apt-get install gnupg2 git rng-tools
        gopass-upstall
}
