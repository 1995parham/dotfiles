#!/usr/bin/env bash

usage() {
    echo "mpv is a versatile, command-line-based media player, known for its high-quality video output, hardware acceleration support, and customization options."
    echo '
 _ __ ___  _ ____   __
| |_ ` _ \| |_ \ \ / /
| | | | | | |_) \ V /
|_| |_| |_| .__/ \_/
          |_|
  '
}

main_brew() {
    require_brew_cask iina
}

main_pacman() {
    # require_aur mpv-git
    require_pacman mpv
}

main() {
    configfile mpv
}
