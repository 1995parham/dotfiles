#!/usr/bin/env bash

usage() {
    echo -n 'have temporary directories at your home'
    echo '
 _
| |_ _ __ ___  _ __
| __| |_ | _ \| |_ \
| |_| | | | | | |_) |
 \__|_| |_| |_| .__/
              |_|
  '
}

main_pacman() {
    configfile user-tmpfiles.d '' 'tmpfiles'
    configsystemd 'tmpfiles' systemd-tmpfiles-clean.timer.d

    service_enable --user systemd-tmpfiles-setup.service
    service_enable --user systemd-tmpfiles-clean.timer

    systemd-tmpfiles --user --create
}

main_brew() {
    copycat "tmpfiles" tmpfiles/cleanup.sh "/usr/local/bin/cleanup.sh" 1

    sudo chmod +x /usr/local/bin/cleanup.sh

    msg 'apple is not working with you because of its security and privacy'
}

main() {
    return 0
}
