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
	require_pacman android-tools android-udev scrcpy
	require_aur sidequest-bin
}
