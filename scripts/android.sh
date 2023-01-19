#!/bin/bash

usage() {
	echo -n -e "tools for communicating with android-based devices"

	echo '
                 _           _     _
  __ _ _ __   __| |_ __ ___ (_) __| |
 / _| | |_ \ / _| | |__/ _ \| |/ _| |
| (_| | | | | (_| | | | (_) | | (_| |
 \__,_|_| |_|\__,_|_|  \___/|_|\__,_|
  '
}

main_pacman() {
	require_pacman android-tools android-udev scrcpy android-file-transfer
	require_aur sidequest-bin

	msg 'https://github.com/skrimix/QLoaderFiles'
	msg 'https://wiki.archlinux.org/title/Media_Transfer_Protocol'
}
