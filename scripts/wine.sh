#!/bin/bash

usage() {
	echo -n "wine is not an emulator"
	# shellcheck disable=2016
	echo '
          _
__      _(_)_ __   ___
\ \ /\ / / | |_ \ / _ \
 \ V  V /| | | | |  __/
  \_/\_/ |_|_| |_|\___|

	'
}

main_pacman() {
	sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

	sudo pacman -Syu

	msg "multilib has been enabled and required packages have been installed"

	require_pacman wine-staging
	msg 'install the 32-bit version of graphics driver.'
	require_pacman lib32-mesa lib32-nvidia-utils
	msg 'the lib32-gnutls package may need to be installed for applications making TLS or HTTPS connections to work'
	require_pacman lib32-gnutls
	msg 'winetricks is a script to allow one to install base requirements needed to run Windows programs'
	require_pacman winetricks
}
