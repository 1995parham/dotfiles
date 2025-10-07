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

    msg "use binaries installed by brew before anything else in the PATH"
    copycat "macos" "osx/paths" "/etc/paths"
}
