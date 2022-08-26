#!/bin/bash

usage() {
	echo -n "A youtube-dl fork with additional features and fixes"
	# shellcheck disable=2016
	echo '
       _            _ _
 _   _| |_       __| | |_ __
| | | | __|____ / _| | | |_ \
| |_| | ||_____| (_| | | |_) |
 \__, |\__|     \__,_|_| .__/
 |___/                 |_|
	'
}

main_pacman() {
	require_pacman yt-dlp
}

main() {
	configfile yt-dlp
}
