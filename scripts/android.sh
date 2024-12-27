#!/usr/bin/env bash

usage() {
    echo -n -e "Tools for communicating with and performing bootloader operations on Android-based devices"

    echo '
                 _           _     _
  __ _ _ __   __| |_ __ ___ (_) __| |
 / _| | |_ \ / _| | |__/ _ \| |/ _| |
| (_| | | | | (_| | | | (_) | | (_| |
 \__,_|_| |_|\__,_|_|  \___/|_|\__,_|
  '
}

main_pacman() {
    require_pacman android-tools android-udev scrcpy android-file-transfer heimdall
    # require_aur sidequest-bin

    #	msg 'https://github.com/skrimix/QLoaderFiles'
    msg 'https://wiki.archlinux.org/title/Media_Transfer_Protocol'
}

main_brew() {
    require_brew scrcpy
    require_brew_cask android-file-transfer android-platform-tools

    if [ ! -f /usr/local/bin/heimdall ]; then
        msg 'install heimdall to upgrade recovery.img on Galaxy Tab S6 Lite (Wi-Fi)'
        image=Heimdall-macOS-master-012220
        wget "https://blob.lineageos.org/downloads/heimdall/$image.dmg"
        hdiutil attach "$image.dmg"
        sudo cp /Volumes/Heimdall/heimdall /usr/local/bin/heimdall
        hdiutil detach /Volumes/Heimdall
        rm "$image.dmg"
    fi
}
