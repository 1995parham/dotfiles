#!/usr/bin/env bash

usage() {
    echo -n "Tools for communicating with and performing bootloader operations on Android-based devices"

    echo '
                 _           _     _
  __ _ _ __   __| |_ __ ___ (_) __| |
 / _| | |_ \ / _| | |__/ _ \| |/ _| |
| (_| | | | | (_| | | | (_) | | (_| |
 \__,_|_| |_|\__,_|_|  \___/|_|\__,_|
  '
}

main_pacman() {
    require_pacman android-tools android-udev android-file-transfer heimdall

    # SideQuest for Quest VR development (uncomment if needed)
    # require_aur sidequest-bin

    # Reference links for additional tools
    # msg 'https://github.com/skrimix/QLoaderFiles'
    msg 'https://wiki.archlinux.org/title/Media_Transfer_Protocol'
}

main_brew() {
    require_brew_cask openmtp android-platform-tools
    # require_brew_cask openmtp

    # if [ ! -f /usr/local/bin/heimdall ]; then
    #     msg 'installing heimdall to upgrade recovery.img on Galaxy Tab S6 Lite (Wi-Fi)'
    #
    #     # Using specific version from 2020-01-22 (last known working version)
    #     local image=Heimdall-macOS-master-012220
    #
    #     msg 'downloading heimdall disk image'
    #     if ! curl -fsSL "https://blob.lineageos.org/downloads/heimdall/$image.dmg" -o "$image.dmg"; then
    #         msg 'failed to download heimdall' 'error'
    #         return 1
    #     fi
    #
    #     msg 'mounting disk image'
    #     if ! hdiutil attach "$image.dmg"; then
    #         msg 'failed to attach disk image' 'error'
    #         rm -f "$image.dmg"
    #         return 1
    #     fi
    #
    #     msg 'copying heimdall binary to /usr/local/bin'
    #     if ! sudo cp /Volumes/Heimdall/heimdall /usr/local/bin/heimdall; then
    #         msg 'failed to copy heimdall binary' 'error'
    #         hdiutil detach /Volumes/Heimdall 2>/dev/null
    #         rm -f "$image.dmg"
    #         return 1
    #     fi
    #
    #     msg 'unmounting disk image'
    #     if ! hdiutil detach /Volumes/Heimdall; then
    #         msg 'failed to detach disk image' 'error'
    #     fi
    #
    #     rm -f "$image.dmg"
    #     msg 'heimdall installed successfully'
    # else
    #     msg 'heimdall already installed'
    # fi
}
