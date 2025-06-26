#!/usr/bin/env bash
usage() {
    echo "AeroSpace is an i3-like tiling window manager for macOS"

    # shellcheck disable=1004,2016
    echo '

  __ _  ___ _ __ ___  ___ _ __   __ _  ___ ___
 / _` |/ _ \ |__/ _ \/ __| |_ \ / _` |/ __/ _ \
| (_| |  __/ | | (_) \__ \ |_) | (_| | (_|  __/
 \__,_|\___|_|  \___/|___/ .__/ \__,_|\___\___|
                         |_|
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
    require_brew_cask nikitabobko/tap/aerospace

    # hide macos dock
    defaults write com.apple.dock autohide -bool true && killall Dock
    defaults write com.apple.dock autohide-delay -float 1000 && killall Dock
    defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock
}

main() {
    return 0
}

main_parham() {
    return 0
}
