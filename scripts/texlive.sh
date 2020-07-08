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
                tlmgr install $@
        else
                sudo tlmgr install $@
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

                message "texlive" "Install texlive with brew"
                brew install texlive

                # https://tex.stackexchange.com/questions/528634/tlmgr-unexpected-return-value-from-verify-checksum-5
                wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh
                chmod +x update-tlmgr-latest.sh
                ./update-tlmgr-latest.sh
                rm update-tlmgr-latest.sh

                # https://tex.stackexchange.com/questions/23164/i-cant-find-the-format-file-xelatex-fmt
                fmtutil-sys --all
        else
                message "texlive" "Darwin"

                message "texlive" "Install basictex with brew"
                brew cask install basictex

                eval "$(/usr/libexec/path_helper)"
        fi
}

main() {
        texlive-install
        texlive-packages

        # brew install texlab
}
