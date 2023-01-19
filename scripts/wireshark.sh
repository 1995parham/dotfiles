#!/bin/bash

usage() {
	echo "Wireshark is the world’s foremost and widely-used network protocol analyzer. Go Deep"

	# shellcheck disable=1004,2016
	echo '
          _               _                _
__      _(_)_ __ ___  ___| |__   __ _ _ __| | __
\ \ /\ / / | |__/ _ \/ __| |_ \ / _| | |__| |/ /
 \ V  V /| | | |  __/\__ \ | | | (_| | |  |   <
  \_/\_/ |_|_|  \___||___/_| |_|\__,_|_|  |_|\_\
  '
}

main_pacman() {
	require_pacman wireshark-qt

	msg "use wireshark as a non-root user"
	sudo groupadd -f wireshark
	sudo usermod -aG wireshark "$USER"

	newgrp wireshark
}
