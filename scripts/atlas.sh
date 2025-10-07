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

install_atlas_from_script() {
    msg 'downloading atlas cli installer'
    local atlas_installer="/tmp/atlas-installer.sh"
    if ! curl -sSfL https://atlasgo.sh -o "$atlas_installer"; then
        msg 'failed to download atlas installer' 'error'
        return 1
    fi

    msg 'running atlas installer'
    if ! sh "$atlas_installer"; then
        msg 'failed to install atlas' 'error'
        rm -f "$atlas_installer"
        return 1
    fi
    rm -f "$atlas_installer"

    msg 'atlas cli installed successfully'
}

main_pacman() {
    install_atlas_from_script
}

main_apt() {
    install_atlas_from_script
}

main_brew() {
    require_brew ariga/tap/atlas
}

main() {
    if command -v atlas &>/dev/null; then
        msg "$(atlas version)"
    else
        msg 'atlas not available in PATH' 'error'
        return 1
    fi
}
