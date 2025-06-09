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
    require_pacman fastfetch onefetch tokei countryfetch
}

main_apt() {
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update

    require_apt fastfetch
}

main_xbps() {
    require_xbps fastfetch onefetch tokei
}

main_pkg() {
    require_pkg fastfetch onefetch tokei
}

main_brew() {
    require_brew fastfetch onefetch tokei
}

# main() {
#
# }
