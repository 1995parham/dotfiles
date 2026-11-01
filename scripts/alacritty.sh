#!/usr/bin/env bash

usage() {
    echo -n "alacritty terminal with jetbrains mono font and configuration"
    # shellcheck disable=2016
    echo '
       _                 _ _   _
  __ _| | __ _  ___ _ __(_) |_| |_ _   _
 / _` | |/ _` |/ __| |__| | __| __| | | |
| (_| | | (_| | (__| |  | | |_| |_| |_| |
 \__,_|_|\__,_|\___|_|  |_|\__|\__|\__, |
                                   |___/
	'
}

root=${root:?"root must be set"}

# JetBrainsMono Nerd Font and color emoji: alacritty has no fallback-font
# option, so emoji come from fontconfig (Noto Color Emoji, linked by font.sh)
# on Linux and from Apple Color Emoji through CoreText on macOS
export dependencies=("font")

main_brew() {
    require_brew_cask alacritty
}

main_apt() {
    require_apt alacritty
}

main_pacman() {
    require_pacman alacritty
}

main() {
    configfile alacritty

    # the naz palette is inlined in alacritty.toml, so the alacritty-theme
    # clone that older runs left inside the linked folder is no longer used
    if [ -d "$root/alacritty/themes/.git" ]; then
        message alacritty 'remove the unused alacritty-theme clone' notice
        rm -rf "$root/alacritty/themes"
    fi
}
