#!/usr/bin/env bash

usage() {
    echo "install nodejs, remember language-servers most of the time need nodejs"
    # shellcheck disable=1004
    echo '
                 _
 _ __   ___   __| | ___
| |_ \ / _ \ / _| |/ _ \
| | | | (_) | (_| |  __/
|_| |_|\___/ \__|_|\___|

  '
}

main_brew() {
    require_brew node pnpm fnm

    msg 'creating husky configuration directory'
    if ! mkdir -p "$HOME/.config/husky"; then
        msg 'failed to create husky config directory' 'error'
        return 1
    fi

    if ! echo "PATH=\"${PATH}\"" >"$HOME/.config/husky/init.sh"; then
        msg 'failed to create husky init script' 'error'
        return 1
    fi
}

main_apt() {
    msg "installing node from nodesource apt repository (https://github.com/nodesource/distributions)"

    local node_version="${NODE_VERSION:-lts}"
    local node_setup="/tmp/nodesource_setup.sh"

    if ! curl -fsSL "https://deb.nodesource.com/setup_${node_version}.x" -o "$node_setup"; then
        msg 'failed to download nodesource setup script' 'error'
        return 1
    fi

    msg 'running nodesource setup script'
    if ! sudo -E bash "$node_setup"; then
        msg 'failed to run nodesource setup' 'error'
        rm -f "$node_setup"
        return 1
    fi
    rm -f "$node_setup"

    msg 'installing nodejs'
    if ! sudo apt-get install -y nodejs; then
        msg 'failed to install nodejs' 'error'
        return 1
    fi
}

main_pkg() {
    require_pkg nodejs
}

main_pacman() {
    require_pacman nodejs npm pnpm
    require_aur fnm
}

main() {
    if command -v node &>/dev/null; then
        msg "$(node -v)"
    else
        msg 'node is not available in PATH' 'error'
        return 1
    fi

    require_mason typescript-language-server
}
