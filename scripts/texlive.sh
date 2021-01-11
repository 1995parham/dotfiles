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

texlive-package() {
        if [[ $OSTYPE == "linux-gnu" ]]; then
                tllocalmgr install $@
        else
                tlmgr install $@
        fi
}

texlive-packages() {
        # elsevier journals
        texlive-package elsarticle

        # xepersian
        texlive-package xepersian bidi zref

        # presentation
        texlive-package beamer beamertheme-metropolis pgfopts

        # references
        texlive-package biblatex biber

        # linters
        texlive-package lacheck chktex

        # make
        texlive-package latexmk
}

texlive-install() {
        if [[ $OSTYPE == "linux-gnu" ]]; then
                message "texlive" "Linux"

                message "texlive" "Download the installer from tug.org"
                if [ ! -d texlive-installer ]; then
                        mkdir texlive-installer
                        curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -x -v -z -f - -C texlive-installer
                else
                        message "texlive" "There is a failed installation of texlive"
                fi

                message "texlive" "Install with the installer -- default scheme is small"
                cd texlive-installer/install-tl*
                sudo ./install-tl -scheme small
        else
                message "texlive" "Darwin"

                message "texlive" "Install basictex with brew"
                brew cask install basictex

                eval "$(/usr/libexec/path_helper)"
        fi
}

main() {
        if [ ! -d /usr/local/texlive ]; then
                texlive-install
        else
                message "texlive" "Remove already installed texlive"
        fi
        texlive-packages
}
