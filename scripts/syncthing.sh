#!/usr/bin/env bash

usage() {
    echo 'Open Source Continuous File Synchronization'
    echo '
                      _   _     _
 ___ _   _ _ __   ___| |_| |__ (_)_ __   __ _
/ __| | | | |_ \ / __| __| |_ \| | |_ \ / _` |
\__ \ |_| | | | | (__| |_| | | | | | | | (_| |
|___/\__, |_| |_|\___|\__|_| |_|_|_| |_|\__, |
     |___/                              |___/
  '
}

# the system unit syncthing@<user> runs as that user from boot, with no login and no linger,
# which is what a machine with no desktop needs.
syncthing_enable() {
    if ! service_enable "syncthing@${USER}.service"; then
        msg 'failed to enable syncthing' 'error'
        return 1
    fi
}

main_pacman() {
    require_pacman syncthing
    syncthing_enable
}

main_apt() {
    require_apt syncthing
    syncthing_enable
}

main_brew() {
    require_brew syncthing

    if ! brew services start syncthing; then
        msg 'failed to start syncthing' 'error'
        return 1
    fi
}

main() {
    msg 'the web interface is at http://127.0.0.1:8384' 'notice'
}
