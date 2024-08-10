#!/bin/bash
usage() {
    echo "Open Broadcaster Software®"

    # shellcheck disable=1004,2016
    echo '
       _
  ___ | |__  ___
 / _ \| |_ \/ __|
| (_) | |_) \__ \
 \___/|_.__/|___/
  '
}

main_pacman() {
    return 0
}

main_apt() {
    return 0
}

main_brew() {
    return 0
}

main() {
    mkdir -p "$HOME/.config/obs-studio" || true

    copycat "obs" "obs/global.ini" "$HOME/.config/obs-studio/global.ini" 0

    mkdir -p "$HOME/.config/obs-studio/basic/profiles/Parham" || true
    mkdir -p "$HOME/.config/obs-studio/basic/scenes" || true

    copycat "obs" "obs/basic/profiles/Parham/basic.ini" "$HOME/.config/obs-studio/basic/profiles/Parham/basic.ini" 0
    copycat "obs" "obs/basic/scenes/Parham.json" "$HOME/.config/obs-studio/basic/scenes/Parham.json" 0
    copycat "obs" "obs/basic/scenes/Teaching.json" "$HOME/.config/obs-studio/basic/scenes/Teaching.json" 0
}

main_parham() {
    return 0
}
