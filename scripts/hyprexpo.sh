#!/usr/bin/env bash
usage() {
    echo "workspace overview for hyprland (sandwichfarm/hyprexpo), built against the running hyprland"

    # shellcheck disable=1004,2016
    echo '
 _
| |__  _   _ _ __  _ __ _____  ___ __   ___
| |_ \| | | | |_ \| |__/ _ \ \/ / |_ \ / _ \
| | | | |_| | |_) | | |  __/>  <| |_) | (_) |
|_| |_|\__, | .__/|_|  \___/_/\_\ .__/ \___/
       |___/|_|                 |_|
  '
}

root=${root:?"root must be set"}

export dependencies=("hyprland")

# hyprexpo left hyprwm/hyprland-plugins as unmaintained (2026-05-12); this fork
# keeps it working on 0.56 and pins a plugin commit per hyprland commit in its
# hyprpm.toml. a plugin runs inside the compositor, so it must match the
# installed hyprland exactly: rerun this script after every hyprland upgrade.
hyprexpo_repo="sandwichfarm/hyprexpo"
hyprexpo_dir="${XDG_DATA_HOME:-$HOME/.local/share}/hyprland/plugins"

main_pacman() {
    require_pacman make gcc pkgconf pixman libdrm pango libinput wayland libxkbcommon lua
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
    local commit pin src
    commit="$(hyprctl version -j | jq -r .commit)"
    pin="$(curl -fsSL "https://raw.githubusercontent.com/${hyprexpo_repo}/HEAD/hyprpm.toml" |
        grep "\"${commit}\"" | grep -oE '[0-9a-f]{40}' | tail -1)"
    if [[ -z "${pin}" ]]; then
        msg "no hyprexpo commit is pinned for hyprland ${commit}, wait for the fork to catch up" "error"
        return 1
    fi

    src="$(mktemp -d)"
    running "hyprexpo" "building ${pin:0:8} for hyprland ${commit:0:8}"
    curl -fsSL "https://codeload.github.com/${hyprexpo_repo}/tar.gz/${pin}" | tar -C "${src}" -xz --strip-components=1
    make -C "${src}" all -j"$(nproc)"

    mkdir -p "${hyprexpo_dir}"
    install -m 0755 "${src}/hyprexpo.so" "${hyprexpo_dir}/hyprexpo.so"
    rm -rf "${src}"
    ok "hyprexpo" "${hyprexpo_dir}/hyprexpo.so: load it with hl.plugin.load(), test it in a nested hyprland first"
}
