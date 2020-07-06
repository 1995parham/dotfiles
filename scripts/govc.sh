#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : govc.sh
#
# [] Creation Date : 17-07-2018
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: govc"
}


govc-upstall() {
        message "govc" "Upstall govc from github"
        govc_vr=$(curl -s https://api.github.com/repos/vmware/govmomi/releases/latest | grep 'tag_name' | cut -d\" -f4)
        hash govc 2> /dev/null && govc version -require=$(echo $govc_vr | cut -dv -f2) 2> /dev/null

        if [ $? -ne 0 ]; then
                message "govc" "Dowloading from github"
                curl -L https://github.com/vmware/govmomi/releases/download/${govc_vr}/govc_$(uname -s | awk '{print tolower($0)}')_amd64.gz | gunzip | sudo tee /usr/local/bin/govc > /dev/null
                sudo chmod +x /usr/local/bin/govc
        fi

        message "govc" "$(govc version)"
}

main() {
        # Reset optind between calls to getopts
        OPTIND=1

        govc-upstall
}
