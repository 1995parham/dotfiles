#!/bin/bash

usage() {
	echo -n -e "a decentralized messenger with a focus on private, secure, and anonymous communications"

	# shellcheck disable=1004,2016
	echo '
                   _
 ___  ___  ___ ___(_) ___  _ __
/ __|/ _ \/ __/ __| |/ _ \| |_ \
\__ \  __/\__ \__ \ | (_) | | | |
|___/\___||___/___/_|\___/|_| |_|
  '
}

main_pacman() {
	require_aur session-desktop-bin
}
