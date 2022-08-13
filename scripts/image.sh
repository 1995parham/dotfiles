#!/bin/bash

usage() {
	echo -n "image manipulation tools including: imagemagick (convert), gimp"
	# shellcheck disable=2016,1004
	echo '
 _
(_)_ __ ___   __ _  __ _  ___
| | |_ ` _ \ / _` |/ _` |/ _ \
| | | | | | | (_| | (_| |  __/
|_|_| |_| |_|\__,_|\__, |\___|
                   |___/
  '
}

main_pacman() {
	require_pacman gimp imagemagick imv
}
