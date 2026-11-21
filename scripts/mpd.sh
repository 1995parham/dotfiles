#!/usr/bin/env bash

usage() {
    echo "mpd music server with ncmpcpp as a client"
    # shellcheck disable=2016
    echo '
                     _
 _ __ ___  _ __   __| |
| |_ ` _ \| "_ \ / _` |
| | | | | | |_) | (_| |
|_| |_| |_| .__/ \__,_|
          |_|
  '
}

main_pacman() {
    require_pacman mpd ncmpcpp mpc
}

main() {
    configfile mpd mpd.conf
    service_enable --user mpd.service
}
