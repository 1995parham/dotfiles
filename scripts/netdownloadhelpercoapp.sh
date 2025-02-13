#!/usr/bin/env bash
usage() {
    echo "Some operations required by Video DownloadHelper cannot be performed from within the browser. In order to be able to still do the job, the add-on relies on our external application that is called transparently."

    # shellcheck disable=1004,2016
    echo '
            _      _                     _                 _ _          _
 _ __   ___| |_ __| | _____      ___ __ | | ___   __ _  __| | |__   ___| |
| |_ \ / _ \ __/ _` |/ _ \ \ /\ / / |_ \| |/ _ \ / _` |/ _` | |_ \ / _ \ |
| | | |  __/ || (_| | (_) \ V  V /| | | | | (_) | (_| | (_| | | | |  __/ |
|_| |_|\___|\__\__,_|\___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|_| |_|\___|_|


 _ __   ___ _ __ ___ ___   __ _ _ __  _ __
| |_ \ / _ \ |__/ __/ _ \ / _` | |_ \| |_ \
| |_) |  __/ | | (_| (_) | (_| | |_) | |_) |
| .__/ \___|_|  \___\___/ \__,_| .__/| .__/
|_|                            |_|   |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
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
    require_brew_cask netdownloadhelpercoapp
}

main() {
    return 0
}

main_parham() {
    return 0
}
