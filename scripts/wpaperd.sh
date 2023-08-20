#!/bin/bash
usage() {
	echo "Wallpaper daemon for Wayland"

	# shellcheck disable=1004,2016
	echo '
                                         _
__      ___ __   __ _ _ __   ___ _ __ __| |
\ \ /\ / / |_ \ / _` | |_ \ / _ \ |__/ _` |
 \ V  V /| |_) | (_| | |_) |  __/ | | (_| |
  \_/\_/ | .__/ \__,_| .__/ \___|_|  \__,_|
         |_|         |_|
  '
}

main_pacman() {
	msg 'setup wpaperd'
	require_aur wpaperd-git

	msg 'setup user-systemd services'
	configsystemd services wpaperd.service sway
}

main_apt() {
	return 1
}

main_brew() {
	return 1
}

main() {
	return 0
}

main_parham() {
	msg 'the wallpapers that we love'

	clone https://github.com/parham-alvani/wallpapers "$HOME/Pictures" "GoSiMac"
}
