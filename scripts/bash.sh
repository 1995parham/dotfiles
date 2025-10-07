#!/usr/bin/env bash

usage() {
    echo "Bash is a Unix shell and command language written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell."

    # shellcheck disable=1004,2016
    echo '
 _               _
| |__   __ _ ___| |__
| |_ \ / _` / __| |_ \
| |_) | (_| \__ \ | | |
|_.__/ \__,_|___/_| |_|
  '
}

root=${root:?"root must be set"}

pre_main() {
    msg "create bashrc if it doesn't exist"
    if [ ! -f "$HOME/.bashrc" ]; then
        if ! echo '#!/usr/bin/env bash' >"$HOME/.bashrc"; then
            msg 'failed to create .bashrc file' 'error'
            return 1
        fi
    fi
}

main_pacman() {
    require_pacman bash bash-completion
}

main_pkg() {
    require_pkg bash bash-completion
}

main_xbps() {
    require_xbps bash bash-completion
}

main_apt() {
    require_apt bash
}

main_brew() {
    require_brew bash bash-completion@2

    local brew_prefix
    brew_prefix="$(brew --prefix)"
    local completion_path="$brew_prefix/etc/profile.d/bash_completion.sh"

    msg "adding bash-completion to .bashrc"
    if ! grep -q "bash_completion.sh" "$HOME/.bashrc"; then
        local completion_line="[[ -r \"$completion_path\" ]] && . \"$completion_path\""
        if ! echo "$completion_line" | tee -a "$HOME/.bashrc" >/dev/null; then
            msg 'failed to append bash-completion to .bashrc' 'error'
            return 1
        fi
    fi
}

main() {
    dotfile "bash" "bashrc.shared"

    msg "source bashrc.shared in bashrc"
    if ! grep -qF "source \"\$HOME/.bashrc.shared\"" "$HOME/.bashrc"; then
        if ! echo "source \"\$HOME/.bashrc.shared\"" | tee -a "$HOME/.bashrc" >/dev/null; then
            msg 'failed to append source command to .bashrc' 'error'
            return 1
        fi
    fi
}
