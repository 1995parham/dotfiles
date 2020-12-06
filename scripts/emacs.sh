#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : emacs.sh
#
# [] Creation Date : 06-12-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================


usage() {
        echo "usage: emacs"
}

main() {
        if [[ "$OSTYPE" == "darwin"* ]]; then
                message "emacs" "Darwin"

                # https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#with-homebrew
                brew install git ripgrep
                brew install emacs
        else
                message "emacs" "Linux"
                if [[ "$(command -v apt)" ]]; then
                        echo "There is nothing that we can do"
                elif [[ "$(command -v pacman)" ]]; then
                        message "emacs" "install emacs/ripgre with pacman"
                        sudo pacman -Syu --noconfirm --needed emacs ripgrep
                fi
        fi

        mkdir -p ~/.config
        git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.config/emacs || true

        ~/.config/emacs/bin/doom install

        configfile doom "" emacs
}
