#!/usr/bin/env bash
usage() {
    echo "Spotify is a digital music service that gives you access to millions of songs."

    # shellcheck disable=1004,2016
    echo '
                 _   _  __
 ___ _ __   ___ | |_(_)/ _|_   _
/ __| |_ \ / _ \| __| | |_| | | |
\__ \ |_) | (_) | |_| |  _| |_| |
|___/ .__/ \___/ \__|_|_|  \__, |
    |_|                    |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_aur spotify
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask spotify
}

main() {
    return 0
}

main_parham() {
    return 0
}
