#!/bin/bash

usage() {
	echo -n -e "a new bootable USB solution"

	echo '
                 _
__   _____ _ __ | |_ ___  _   _
\ \ / / _ \ |_ \| __/ _ \| | | |
 \ V /  __/ | | | || (_) | |_| |
  \_/ \___|_| |_|\__\___/ \__, |
                          |___/
  '
}

main_pacman() {
	require_aur ventoy-bin
}
