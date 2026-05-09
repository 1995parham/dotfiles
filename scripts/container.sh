#!/usr/bin/env bash

usage() {
    echo "container engine selector — install CLI tools then choose engine(s) to install"

    # shellcheck disable=1004,2016
    echo '
                  _        _
  ___ ___  _ __ | |_ __ _(_)_ __   ___ _ __
 / __/ _ \| |_ \| __/ _` | | |_ \ / _ \ |__|
| (_| (_) | | | | || (_| | | | | |  __/ |
 \___\___/|_| |_|\__\__,_|_|_| |_|\___|_|
  '
}

root=${root:?"root must be set"}

# Engines available per platform. The framework prompts per item.
if [[ "${OSTYPE}" == "darwin"* ]]; then
    export additionals=("docker" "podman" "colima")
else
    export additionals=("docker" "podman")
fi

# The selector itself installs nothing; deps + additionals do the work.
main_brew() { return 0; }
main_apt() { return 0; }
main_pacman() { return 0; }
main_xbps() { return 0; }

main() {
    msg 'pick one or more engines from the prompts that follow.' 'notice'
}
