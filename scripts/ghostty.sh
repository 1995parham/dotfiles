#!/usr/bin/env bash

usage() {
    echo "Ghostty is a fast, native terminal emulator (AppKit + Metal on macOS, GTK4 on Linux) with a flat config file"

    # shellcheck disable=1004,2016
    echo '
       _               _   _
  __ _| |__   ___  ___| |_| |_ _   _
 / _` | |_ \ / _ \/ __| __| __| | | |
| (_| | | | | (_) \__ \ |_| |_| |_| |
 \__, |_| |_|\___/|___/\__|\__|\__, |
 |___/                         |___/
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman ghostty
}

# The cask is marked auto_updates: Ghostty updates itself on relaunch, so a
# plain `brew upgrade` leaves the running app bundle alone. That is the reason
# to prefer it over wezterm@nightly, whose bundle `brew upgrade --greedy`
# replaces under the running process (which loses access to ~/Documents until
# the terminal is restarted).
main_brew() {
    require_brew_cask ghostty
}

main() {
    configfile ghostty

    # The brew cask does not link the binary into PATH; it lives in the bundle.
    local ghostty_bin
    ghostty_bin="$(command -v ghostty || true)"
    if [[ -z "${ghostty_bin}" && -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]]; then
        ghostty_bin=/Applications/Ghostty.app/Contents/MacOS/ghostty
    fi

    if [[ -z "${ghostty_bin}" ]]; then
        msg 'ghostty binary not found, the configuration was not validated' 'notice'
    elif "${ghostty_bin}" +validate-config &>/dev/null; then
        msg 'configuration is valid' 'success'
    else
        msg "configuration has problems, run: ${ghostty_bin} +validate-config" 'warn'
    fi
}

main_parham() {
    return 0
}
