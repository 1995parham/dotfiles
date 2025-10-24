#!/usr/bin/env bash

usage() {
    echo -n "the minimal, blazing-fast, and infinitely customizable prompt for any shell!"
    echo '
     _                 _     _
 ___| |_ __ _ _ __ ___| |__ (_)_ __
/ __| __/ _| | |__/ __| |_ \| | |_ \
\__ \ || (_| | |  \__ \ | | | | |_) |
|___/\__\__,_|_|  |___/_| |_|_| .__/
                              |_|
  '
}

main_apt() {
    if require_apt starship; then
        return 0
    fi

    msg "starship not available in apt, installing via https://starship.rs/install.sh" "notice"

    export BIN_DIR="$HOME/.local/bin"
    curl -SS https://raw.githubusercontent.com/starship/starship/refs/heads/master/install/install.sh | sh
}

main_pkg() {
    require_pkg starship
}

main_pacman() {
    require_pacman starship
}

main_xbps() {
    require_xbps starship
}

main_brew() {
    require_brew starship
}

main() {
    configrootfile starship starship.toml ""
}
