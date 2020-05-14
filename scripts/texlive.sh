#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : texlive.sh
#
# [] Creation Date : 14-05-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: texlive"
}

texlive-packages() {
        sudo tlmgr install elsarticle
}

texlive-install() {
	if [[ $OSTYPE == "linux-gnu" ]]; then
		message "texlive" "Linux"

                message "texlive" "Install texlive-basic with apt"
                sudo apt install texlive-basic
	else
		message "texlive" "Darwin"

                message "texlive" "Install basictex with brew"
		brew cask install basictex
	fi
}

main() {
        texlive-install
        texlive-packages
}
