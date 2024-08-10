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

export dependencies=("rust")

main_brew() {
    require_brew_cask alacritty
}

main_pacman() {
    if yes_or_no 'alacritty' 'do you want to use stable release?'; then
        not_require_pacman alacritty-git
        require_pacman alacritty
    else
        not_require_pacman alacritty
        require_aur alacritty-git
    fi
}

main() {
    configfile alacritty
}
