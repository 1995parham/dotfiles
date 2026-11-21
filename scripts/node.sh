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

# pnpm is the package manager on every platform. it comes from the system package where one
# exists, and from npm on debian. corepack is not used: node no longer ships it since v25.

main_brew() {
    require_brew node pnpm

    # husky runs git hooks with a bare PATH, so a hook started by a gui client on macos does
    # not find the node of homebrew. husky sources this file first.
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
    if ! grep -qsF "deb.nodesource.com" /etc/apt/sources.list.d/nodesource.sources /etc/apt/sources.list.d/nodesource.list; then
        msg "adding the nodesource apt repository (https://github.com/nodesource/distributions)"

        local node_version="${NODE_VERSION:-lts}"
        local node_setup
        node_setup=$(mktemp)

        if ! curl -fsSL "https://deb.nodesource.com/setup_${node_version}.x" -o "$node_setup"; then
            msg 'failed to download nodesource setup script' 'error'
            rm -f "$node_setup"
            return 1
        fi

        msg 'running nodesource setup script'
        if ! sudo -E bash "$node_setup"; then
            msg 'failed to run nodesource setup' 'error'
            rm -f "$node_setup"
            return 1
        fi
        rm -f "$node_setup"
    fi

    msg 'installing nodejs'
    if ! require_apt nodejs; then
        msg 'failed to install nodejs' 'error'
        return 1
    fi

    require_npm pnpm
}

main_pkg() {
    require_pkg nodejs
}

main_pacman() {
    require_pacman nodejs npm pnpm
}

main() {
    if ! command -v node &>/dev/null; then
        msg 'node is not available in PATH' 'error'
        return 1
    fi

    msg "node $(node -v), npm $(npm -v)"
    if command -v pnpm &>/dev/null; then
        msg "pnpm $(pnpm -v)"
    fi

    if command -v nvim &>/dev/null; then
        require_mason typescript-language-server
    fi
}
