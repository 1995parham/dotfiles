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

main_pacman() {
    require_pacman syncthing

    sudo systemctl enable "syncthing@$USER"
    sudo systemctl start "syncthing@$USER"
}

main_brew() {
    brew install syncthing
    brew services start syncthing
}

main() {
    return 0
}
