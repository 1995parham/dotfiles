#!/usr/bin/env bash

usage() {
    echo -n "a command-line system/repository information tool"
    # shellcheck disable=2016
    echo '
  __      _       _
 / _| ___| |_ ___| |__
| |_ / _ \ __/ __| |_ \
|  _|  __/ || (__| | | |
|_|  \___|\__\___|_| |_|
	'
}

main_pacman() {
    require_pacman neofetch onefetch tokei
}

main_apt() {
    require_apt neofetch
}

main_xbps() {
    require_xbps neofetch onefetch tokei
}

main_brew() {
    require_brew neofetch onefetch tokei
}

main() {
    configfile neofetch
}
