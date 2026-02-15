#!/usr/bin/env bash

usage() {
    echo -n "aur's packages maintain by 1995parham"

    echo '
  __ _ _   _ _ __
 / _| | | | | |__|
| (_| | |_| | |
 \__,_|\__,_|_|

  '
}

main_pacman() {
    require_pacman pacman-contrib
}

main() {
    pkgs=(
        "natscli"
        "natscli-bin"
        "natscli-git"
        "okd-client-bin"
        "gosimac-bin"
        "gosimac"
        "jcal"
        "gotz"
        "mprocs"
        "scitopdf-git"
        "jira-cli"
        "dijo-1995parham"
        "rpk-bin"
        #		"litmusctl-bin"
    )

    for pkg in "${pkgs[@]}"; do
        clone "aur@aur.archlinux.org:$pkg" "$HOME/Documents/Git/aur"
    done
}
