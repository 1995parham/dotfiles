#!/usr/bin/env bash

usage() {
    echo "exercism, the command line client of exercism.org"
    # shellcheck disable=1004
    echo '
                        _
  _____  _____ _ __ ___(_)___ _ __ ___
 / _ \ \/ / _ \ |__/ __| / __| |_ ` _ \
|  __/>  <  __/ | | (__| \__ \ | | | | |
 \___/_/\_\___|_|  \___|_|___/_| |_| |_|
	'
}

main_brew() {
    require_brew exercism
}

main_pacman() {
    require_aur exercism-bin
}

main_apt() {
    # debian has no package, so the binary comes from the release into ~/.local/bin.
    local arch
    case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *)
        msg "no exercism release for $(uname -m)" 'error'
        return 1
        ;;
    esac

    require_github_release "exercism/cli" "exercism" "exercism-\${version#v}-linux-${arch}" "tar.gz"
}

main() {
    if ! command -v exercism &>/dev/null; then
        msg 'exercism is not available in PATH' 'error'
        return 1
    fi

    msg "$(exercism version)"

    # the token is on https://exercism.org/settings/api_cli
    if [[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/exercism/user.json" ]]; then
        msg 'run "exercism configure --token=<token>" once to log in' 'notice'
    fi
}
