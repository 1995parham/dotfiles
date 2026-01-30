#!/usr/bin/env bash

usage() {
    echo -n 'full-flagged terminal'

    echo '
 _    _ _   _
| | _(_) |_| |_ _   _
| |/ / | __| __| | | |
|   <| | |_| |_| |_| |
|_|\_\_|\__|\__|\__, |
                |___/
  '
}

main_apt() {
    require_apt kitty fonts-jetbrains-mono
}

main_pacman() {
    require_pacman kitty
}

main_brew() {
    require_brew_cask kitty
}

main() {
    configfile kitty
}
