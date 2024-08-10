#!/usr/bin/env bash

usage() {
    echo "fonts for terminal, subtitles and more"
    echo '
  __             _
 / _| ___  _ __ | |_
| |_ / _ \| |_ \| __|
|  _| (_) | | | | |_
|_|  \___/|_| |_|\__|

  '
}

main_brew() {
    require_brew_cask \
        font-jetbrains-mono \
        font-jetbrains-mono-nerd-font \
        font-vazirmatn \
        font-dejavu \
        font-fira-code-nerd-font \
        font-fira-code \
        font-roboto
}

main_pacman() {
    require_pacman noto-fonts-emoji ttf-roboto ttf-jetbrains-mono ttf-font-awesome ttf-dejavu noto-fonts \
        otf-font-awesome ttf-liberation ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-firacode-nerd ttf-fira-code
    require_aur vazirmatn-fonts

    configfile fontconfig
    fc-cache -f
}
