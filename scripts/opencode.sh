#!/usr/bin/env bash

usage() {
    echo "opencode - an open-source AI coding agent in your terminal"
    # shellcheck disable=2016
    echo '
  ___  _ __   ___ _ __   ___ ___   __| | ___
 / _ \| |_ \ / _ \ |_ \ / __/ _ \ / _` |/ _ \
| (_) | |_) |  __/ | | | (_| (_) | (_| |  __/
 \___/| .__/ \___|_| |_|\___\___/ \__,_|\___|
      |_|
    '
}

root=${root:?"root must be set"}

main_brew() {
    require_brew opencode
}

main_pacman() {
    require_aur opencode-ai-bin
}

main_apt() {
    require_npm opencode-ai
}

main_pkg() {
    require_npm opencode-ai
}

main() {
    local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
    local theme_dir="${config_dir}/themes"

    mkdir -p "${theme_dir}" || true

    linker "opencode" "$root/opencode/opencode.json" "${config_dir}/opencode.json"
    linker "opencode" "$root/opencode/themes/neon.json" "${theme_dir}/neon.json"

    msg "opencode configured with neon theme" "success"
}
