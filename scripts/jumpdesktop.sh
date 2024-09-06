#!/usr/bin/env bash

usage() {
    echo "Jump Desktop is a secure and reliable remote desktop app that lets you connect to any computer, anywhere in the world."

    # shellcheck disable=1004,2016
    printf '
   _                           _           _    _
  (_)_   _ _ __ ___  _ __   __| | ___  ___| | _| |_ ___  _ __
  | | | | | |_ | _ \| |_ \ / _| |/ _ \/ __| |/ / __/ _ \| |_ \
  | | |_| | | | | | | |_) | (_| |  __/\__ \   <| || (_) | |_) |
 _/ |\____|_| |_| |_| |__/ \__|_|\___||___/_|\_\\__\___/| |__/
|__/                |_|                                 |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    if [ ! -f jdmac.zip ]; then
        curl -L https://jumpdesktop.com/downloads/jdmac >jdmac.zip
    fi
    unzip jdmac.zip
    sudo mv 'Jump Desktop.app/' /Applications/
    rm jdmac.zip
}

main() {
    return 0
}

main_parham() {
    return 0
}
