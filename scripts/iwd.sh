#!/usr/bin/env bash
usage() {
    echo "iNet wireless daemon, is a wireless daemon for Linux written by Intel"

    # shellcheck disable=1004,2016
    echo '
 _             _
(_)_      ____| |
| \ \ /\ / / _` |
| |\ V  V / (_| |
|_| \_/\_/ \__,_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman iwd
}

main() {
    copycat "iwd" "iwd/wifi-backend.conf" "/etc/NetworkManager/conf.d/wifi-backend.conf"
    msg 'https://wiki.archlinux.org/title/NetworkManager#Using_iwd_as_the_Wi-Fi_backend' 'notice'
}
