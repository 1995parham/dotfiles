#!/usr/bin/env bash
usage() {
    echo "Atlas is a language-independent tool for managing and migrating database schemas using modern DevOps principles."

    # shellcheck disable=1004,2016
    echo '
       _   _
  __ _| |_| | __ _ ___
 / _` | __| |/ _` / __|
| (_| | |_| | (_| \__ \
 \__,_|\__|_|\__,_|___/
  '
}

main_pacman() {
    msg 'download and install the latest release of the atlas cli'
    curl -sSf https://atlasgo.sh | sh
}

main_apt() {
    msg 'download and install the latest release of the atlas cli'
    curl -sSf https://atlasgo.sh | sh
}

main_brew() {
    require_brew ariga/tap/atlas
}

main() {
    return 0
}
