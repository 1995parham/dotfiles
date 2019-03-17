#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : oc.sh
#
# [] Creation Date : 12-03-2019
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: oc"
}

oc-install() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "oc" "Linux"

                message "oc" "Upstall openshift-cli from github"
	        oc_vr=$(curl -s https://api.github.com/repos/openshift/origin/releases/latest | grep 'tag_name' | cut -d\" -f4)

                message "oc" "Dowloading from github"
                url=$(curl -s https://api.github.com/repos/openshift/origin/releases/latest | grep -E "https://github.com/openshift/origin/releases/download/${oc_vr}/openshift-origin-client-tools-${oc_vr}-[[:alnum:]]{7}-linux-64bit.tar.gz" | cut -d\" -f4)
                curl -L $url | tar -xvz --wildcards --no-anchored '*oc*' | sudo tee /usr/local/bin/oc > /dev/null
                sudo chmod +x /usr/local/bin/oc
	else
		message "forticlient" "Darwin"

                message "forticlient" "Install openshift-cli from brew"
		brew install openshift-cli
	fi
}


main() {
        # Reset optind between calls to getopts
        OPTIND=1

        oc-install
}
