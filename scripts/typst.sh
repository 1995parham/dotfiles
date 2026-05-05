#!/usr/bin/env bash

usage() {
    echo -n "Typst is a new markup-based typesetting system that is designed to be as powerful as LaTeX while being much easier to learn and use."
    # shellcheck disable=1004
    echo '
 _                 _
| |_ _   _ _ __  ___| |_
| __| | | | |_ \/ __| __|
| |_| |_| | |_) \__ \ |_
 \__|\__, | .__/|___/\__|
     |___/|_|
	'
}

main_pacman() {
    require_pacman typst typstyle tinymist ttf-font-awesome
}

main_brew() {
    require_brew typst typstyle tinymist
    require_brew_cask font-fontawesome
}

main_apt() {
    return 1
}

main_xbps() {
    return 1
}
