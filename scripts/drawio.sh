#!/bin/bash

usage() {
	echo -n -e "draw.io desktop application"

	# shellcheck disable=1004,2016
	echo '
     _                    _
  __| |_ __ __ ___      _(_) ___
 / _` | |__/ _` \ \ /\ / / |/ _ \
| (_| | | | (_| |\ V  V /| | (_) |
 \__,_|_|  \__,_| \_/\_/ |_|\___/

  '
}

main_pacman() {
	require_aur drawio-desktop-bin
}

main_brew() {
	brew install --cask drawio
}
