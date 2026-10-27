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
    # arch ships opencode in extra now, the aur package is for older mirrors
    if pacman -Si opencode >/dev/null 2>&1; then
        require_pacman opencode
    else
        require_aur opencode-ai-bin
    fi
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

    # opencode reads one global config, so where ollama runs the shared file
    # is written out with the local model as the default, or opencode starts
    # on its own cloud model. rm first: writing through the link would change
    # the shared file.
    if command -v ollama >/dev/null 2>&1; then
        rm -f "${config_dir}/opencode.json"
        jq '. + {model: "ollama/qwen3:8b"}' "$root/opencode/opencode.json" >"${config_dir}/opencode.json"
        action "opencode" "opencode.json written with ollama/qwen3:8b as the default model"
    else
        linker "opencode" "$root/opencode/opencode.json" "${config_dir}/opencode.json"
    fi
    linker "opencode" "$root/opencode/themes/neon.json" "${theme_dir}/neon.json"

    # the background service keeps the config it started with
    opencode reload >/dev/null 2>&1 || true

    msg "opencode configured with neon theme" "success"
}
