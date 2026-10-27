#!/usr/bin/env bash
usage() {
    echo "firmware updates from the linux vendor firmware service"

    # shellcheck disable=1004,2016
    echo '
  __                          _
 / _|_      ___   _ _ __   __| |
| |_\ \ /\ / / | | | |_ \ / _` |
|  _|\ V  V /| |_| | |_) | (_| |
|_|   \_/\_/  \__,_| .__/ \__,_|
                   |_|
  '
}

root=${root:?"root must be set"}

main_pacman() {
    require_pacman fwupd

    # the weekly metadata refresh; lvfs (cdn.fwupd.org) is foreign, so in iran
    # it only works through a tunnel (sb-roam on simorgh)
    sudo systemctl enable --now fwupd-refresh.timer
}

main_xbps() {
    return 1
}

main_apt() {
    require_apt fwupd
}

main_pkg() {
    return 1
}

main_brew() {
    return 1
}

main() {
    fwupdmgr refresh --force || true
    fwupdmgr get-devices --show-all-devices=false || true

    # a firmware flash reboots and cannot be undone: list, then ask
    if fwupdmgr get-updates; then
        if yes_or_no "fwupd" "apply these firmware updates now (it may reboot)?"; then
            fwupdmgr update
        fi
    fi
}
