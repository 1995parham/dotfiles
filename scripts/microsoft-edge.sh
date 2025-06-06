#!/usr/bin/env bash

usage() {
    echo "Microsoft Edge is a modern, Chromium-based web browser from Microsoft, offering built-in AI-powered features, performance, and security tools."

    # shellcheck disable=1004,2016
    echo '
           _                           __ _                 _
 _ __ ___ (_) ___ _ __ ___  ___  ___  / _| |_       ___  __| | __ _  ___
| |_ ` _ \| |/ __| |__/ _ \/ __|/ _ \| |_| __|____ / _ \/ _` |/ _` |/ _ \
| | | | | | | (__| | | (_) \__ \ (_) |  _| ||_____|  __/ (_| | (_| |  __/
|_| |_| |_|_|\___|_|  \___/|___/\___/|_|  \__|     \___|\__,_|\__, |\___|
                                                              |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    require_brew_cask microsoft-edge@beta
}

main() {
    return 0
}

main_parham() {
    msg '(beta): working profiles'
    msg ''
    msg 'Profile (company): <company-email> - <first-name> (<company-name>)'
}
