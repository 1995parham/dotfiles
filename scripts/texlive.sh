#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : texlive.sh
#
# [] Creation Date : 14-05-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================
linter=false

usage() {
        echo "usage: texlive [-l]"
}

texlive-package() {
        if [[ $OSTYPE == "linux-gnu" ]]; then
                tllocalmgr install $@
        else
                tlmgr install $@
        fi
}

texlive-linter() {
        # linters
        texlive-package latexindent
        cpan YAML::Tiny
        cpan File::HomeDir
        cpan Unicode::GCString
        cpan Log::Log4perl
        cpan Log::Dispatch
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

                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "texlive" "Install texlive-core with pacman"
                        sudo pacman -Syu --needed --noconfirm texlive-core
                        yay -Syu --needed --noconfirm tllocalmgr-git
                fi
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

        # Reset optind between calls to getopts
        OPTIND=1
        while getopts "l" argv; do
                case $argv in
                        l)
                                linter=true
                                ;;
                esac
        done

        if [ $linter = true ]; then
                texlive-linter
        fi
}
