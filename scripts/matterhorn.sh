#!/usr/bin/env bash

usage() {
    echo -n "A feature-rich terminal client for the Mattermost chat system."
    # shellcheck disable=2016
    echo '
                 _   _            _
 _ __ ___   __ _| |_| |_ ___ _ __| |__   ___  _ __ _ __
| |_ ` _ \ / _` | __| __/ _ \ |__| |_ \ / _ \| |__| |_ \
| | | | | | (_| | |_| ||  __/ |  | | | | (_) | |  | | | |
|_| |_| |_|\__,_|\__|\__\___|_|  |_| |_|\___/|_|  |_| |_|
	'
}

main_pacman() {
    require_aur matterhorn-bin
}

main_brew() {
    require_github_release \
        "matterhorn-chat/matterhorn" \
        "matterhorn" \
        "matterhorn-\${version}-Darwin-\$(uname -m)" \
        "tar.bz2"
}

main_apt() {
    require_github_release \
        "matterhorn-chat/matterhorn" \
        "matterhorn" \
        "matterhorn-\${version}-ubuntu-22.04-jammy-x86_64" \
        "tar.bz2"
}

main_snap() {
    require_snap matterhorn
}
