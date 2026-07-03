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
    # bash-completion@2 is loaded lazily (on first <Tab>) from bashrc.shared's
    # darwin block, so we only need the package here — do NOT append an eager
    # `source .../bash_completion.sh` to .bashrc; that re-adds ~0.6s of startup
    # by sourcing the whole compat dir on every launch.
    require_brew bash bash-completion@2
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
