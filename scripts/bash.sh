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
        echo '#!/usr/bin/env bash' >"$HOME/.bashrc"
    fi
}

main_pacman() {
    require_pacman bash bash-completion
}

main_apt() {
    require_apt bash
}

main_brew() {
    require_brew bash bash-completion@2

    msg "bash-completion caveats"
    if ! grep -qF '[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"' \
        "$HOME/.bashrc"; then

        echo '[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"' |
            tee -a "$HOME/.bashrc"

    fi
}

main() {
    dotfile "bash" "bashrc.shared"

    msg "source bashrc.shared in bashrc"
    if ! grep -qF "source \"\$HOME/.bashrc.shared\"" "$HOME/.bashrc"; then
        echo "source \"\$HOME/.bashrc.shared\"" | tee -a "$HOME/.bashrc"
    fi
}
