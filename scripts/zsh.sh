#!/usr/bin/env bash
usage() {
    echo "The Z shell is a Unix shell that can be used as an interactive login shell and as a command interpreter for shell scripting."

    # shellcheck disable=1004,2016
    echo '
         _
 _______| |__
|_  / __| |_ \
 / /\__ \ | | |
/___|___/_| |_|
  '
}

root=${root:?"root must be set"}

pre_main() {
    msg "create zshrc if it doesn't exist"
    if [ ! -f "$HOME/.zshrc" ]; then
        if ! touch "$HOME/.zshrc"; then
            msg 'failed to create .zshrc file' 'error'
            return 1
        fi
    fi
}

main_pacman() {
    require_pacman zsh
}

main_xbps() {
    require_xbps zsh
}

main_pkg() {
    require_pkg zsh
}

main_apt() {
    require_apt zsh
}

main_brew() {
    require_brew zsh zsh-completions

    if ! grep -q -F "if type brew &>/dev/null; then" "$HOME/.zshrc"; then
        msg 'adding brew completions to .zshrc'
        if ! tee -a "$HOME/.zshrc" >/dev/null <<'EOL'; then
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$FPATH
  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi
EOL
            msg 'failed to append brew completions to .zshrc' 'error'
            return 1
        fi
    fi

    local brew_prefix
    brew_prefix="$(brew --prefix)"

    msg 'setting permissions on zsh completion directories'
    if ! chmod go-w "$brew_prefix/share" 2>/dev/null; then
        msg 'failed to set permissions on brew share directory (this may be normal)' 'warning'
    fi

    if ! chmod -R go-w "$brew_prefix/share/zsh" 2>/dev/null; then
        msg 'failed to set permissions on zsh completions directory (this may be normal)' 'warning'
    fi

    rm -f "$HOME/.zcompdump"
}

main() {
    dotfile "zsh" "zshrc.shared"
    dotfile "zsh" "zshenv"
    dotfile "zsh" "zsh.plug"

    msg 'source zshrc.shared'
    if ! grep -q -F "source \"\$HOME/.zshrc.shared\"" "$HOME/.zshrc"; then
        if ! echo "source \"\$HOME/.zshrc.shared\"" | tee -a "$HOME/.zshrc" >/dev/null; then
            msg 'failed to append source command to .zshrc' 'error'
            return 1
        fi
    fi
}
