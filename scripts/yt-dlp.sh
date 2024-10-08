#!/usr/bin/env bash

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

main_brew() {
    require_brew yt-dlp ffmpeg
}

main() {
    configfile yt-dlp
}
