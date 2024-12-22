#!/usr/bin/env bash
usage() {
    echo "setup systemd-resolved to work with network manager"

    # shellcheck disable=1004,2016
    echo '
            _                      _
 _ __   ___| |___      _____  _ __| | __     _ __ ___   __ _ _ __   __ _  __ _
| |_ \ / _ \ __\ \ /\ / / _ \| |__| |/ /____| |_ ` _ \ / _` | |_ \ / _` |/ _` |
| | | |  __/ |_ \ V  V / (_) | |  |   <_____| | | | | | (_| | | | | (_| | (_| |
|_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\    |_| |_| |_|\__,_|_| |_|\__,_|\__, |
                                                                         |___/

  ___ _ __
 / _ \ |__|
|  __/ |
 \___|_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman systemd-resolvconf

    printf '[main]\nsystemd-resolved=false' | sudo tee '/etc/NetworkManager/conf.d/no-systemd-resolved.conf'

    sudo systemctl restart NetworkManager
    sudo systemctl enable --now systemd-resolved.service
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    return 1
}

main() {
    return 0
}

main_parham() {
    return 0
}
