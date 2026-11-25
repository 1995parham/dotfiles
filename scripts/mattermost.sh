#!/usr/bin/env bash

usage() {
    echo -n -e "desktop client for mattermost, the open-source and self-hosted slack alternative"

    # shellcheck disable=1004,2016
    echo '
                 _   _                                _
 _ __ ___   __ _| |_| |_ ___ _ __ _ __ ___   ___  ___| |_
| |_ ` _ \ / _` | __| __/ _ \ |__| |_ ` _ \ / _ \/ __| __|
| | | | | | (_| | |_| ||  __/ |  | | | | | | (_) \__ \ |_
|_| |_| |_|\__,_|\__|\__\___|_|  |_| |_| |_|\___/|___/\__|
  '
}

export additionals=("matterhorn")

main_pacman() {
    require_pacman mattermost-desktop
}

main_brew() {
    require_brew_cask mattermost
}

main_apt() {
    require_snap mattermost-desktop
}
