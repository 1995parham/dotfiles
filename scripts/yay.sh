#!/usr/bin/env bash

export dependencies=("go")

usage() {
    echo -n "Yet another Yogurt - An AUR Helper written in Go"
    # shellcheck disable=2016
    echo '
 _   _  __ _ _   _ 
| | | |/ _` | | | |
| |_| | (_| | |_| |
 \__, |\__,_|\__, |
 |___/       |___/ 
	'
}

main_pacman() {
    if ! pacman -Qi "yay" >/dev/null 2>&1; then
        action "require" "makepkg -si yay from aur source"
        git clone --branch yay --single-branch https://github.com/archlinux/aur.git "$HOME/yay" 2>/dev/null || true
        cd "$HOME/yay" && makepkg -si
    fi
}
