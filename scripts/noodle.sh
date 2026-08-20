#!/usr/bin/env bash

usage() {
    echo "noodle - a delicious REST client for your terminal"
    # shellcheck disable=2016
    echo '
                       _ _
 _ __   ___   ___   __| | | ___
| |_ \ / _ \ / _ \ / _` | |/ _ \
| | | | (_) | (_) | (_| | |  __/
|_| |_|\___/ \___/ \__,_|_|\___|
    '
}

# upstream ships plain binaries (no archive) named noodle-<os>-<arch>, and
# publishes no macOS x86_64 build at all.
noodle_release() {
    local os=$1

    case "$(uname -m)" in
    arm64 | aarch64)
        echo "noodle-${os}-arm64"
        ;;
    x86_64 | amd64)
        if [[ "${os}" == "macos" ]]; then
            msg 'upstream publishes no macOS x86_64 build' 'error'
            return 1
        fi
        echo "noodle-${os}-x86_64"
        ;;
    *)
        msg "unsupported architecture $(uname -m)" 'error'
        return 1
        ;;
    esac
}

noodle_install() {
    local release
    if ! release=$(noodle_release "$1"); then
        return 1
    fi

    require_github_release "wilfredinni/noodle" "noodle" "${release}"
}

main_brew() {
    noodle_install "macos"
}

main_apt() {
    noodle_install "linux"
}

main_pacman() {
    noodle_install "linux"
}

main_xbps() {
    noodle_install "linux"
}

main_pkg() {
    noodle_install "linux"
}
