#!/usr/bin/env bash

usage() {
    echo "console carddav client"
    # shellcheck disable=2016
    echo '
 _    _           _
| | _| |__   __ _| |
| |/ / |_ \ / _| | |
|   <| | | | (_| | |
|_|\_\_| |_|\__,_|_|
  '
}

main_pacman() {
    require_pacman khal
}

main_brew() {
    require_brew khal
}

main() {
    configfile khal config
}

main_parham() {
    clone git@github.com:parham-alvani/calendar "$HOME/Documents/Git/parham/parham-alvani/"
}
