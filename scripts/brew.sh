#!/usr/bin/env bash

usage() {
    echo "The missing package manager for macOS (not Linux)"
    echo '
 _
| |__  _ __ _____      __
| |_ \| |__/ _ \ \ /\ / /
| |_) | | |  __/\ V  V /
|_.__/|_|  \___| \_/\_/

  '
}

main_brew() {
    if ! command -v brew &>/dev/null; then
        msg 'installing Xcode Command Line Tools (this may prompt for password)'
        if ! xcode-select --install 2>/dev/null; then
            msg 'Xcode Command Line Tools already installed or installation failed'
        fi

        msg 'downloading Homebrew installer'
        local brew_installer="/tmp/homebrew-installer.sh"
        if ! curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brew_installer"; then
            msg 'failed to download Homebrew installer' 'error'
            return 1
        fi

        msg 'running Homebrew installer'
        if ! /usr/bin/env bash "$brew_installer"; then
            msg 'failed to install Homebrew' 'error'
            rm -f "$brew_installer"
            return 1
        fi
        rm -f "$brew_installer"
    fi

    # Detect brew path (ARM vs Intel Mac)
    local brew_path
    if [ -x "/opt/homebrew/bin/brew" ]; then
        brew_path="/opt/homebrew/bin/brew"
    elif [ -x "/usr/local/bin/brew" ]; then
        brew_path="/usr/local/bin/brew"
    else
        msg 'brew binary not found after installation' 'error'
        return 1
    fi

    if [ ! -f "$HOME/.zprofile" ]; then
        if ! touch "$HOME/.zprofile"; then
            msg 'failed to create .zprofile file' 'error'
            return 1
        fi
    fi

    # shellcheck disable=2016
    local shellenv_line='eval "$('"$brew_path"' shellenv)"'
    if ! grep -q -F "$brew_path shellenv" "$HOME/.zprofile"; then
        msg 'adding brew shellenv to .zprofile'
        if ! (
            echo
            echo "$shellenv_line"
        ) | tee -a "$HOME/.zprofile" >/dev/null; then
            msg 'failed to append to .zprofile' 'error'
            return 1
        fi
    fi

    # provides brew in the current shell
    eval "$("$brew_path" shellenv)"

    # HOMEBREW_REQUIRE_TAP_TRUST=1 (set in our shell env) makes brew refuse to
    # load non-official taps until they are trusted, so pre-trust the ones these
    # dotfiles actually install from. `brew trust` is idempotent and accepts
    # taps that have not been tapped yet.
    msg "trust the non-official brew taps used by these dotfiles"
    local trusted_taps=(
        1995parham/tap
        hashicorp/tap
        mike-engel/jwt-cli
        nats-io/nats-tools
        redpanda-data/tap
        tilt-dev/tap
    )
    local tap
    for tap in "${trusted_taps[@]}"; do
        if ! brew trust --tap "$tap" >/dev/null 2>&1; then
            msg "failed to trust tap $tap" 'error'
        fi
    done

    # macOS ships bash 3.2 (no associative arrays); install a modern bash so the
    # other scripts (e.g. env.sh) work once a new shell picks brew up on the PATH.
    msg "install a modern bash (macOS ships bash 3.2, too old for some scripts)"
    require_brew bash

    msg "use binaries installed by brew before anything else in the PATH"
    copycat "macos" "osx/paths" "/etc/paths"
}
