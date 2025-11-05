#!/usr/bin/env bash

export dependencies=("neovim-core" "node" "go" "python")
export additionals=("shell" "java")

lsp_servers() {
    return 0
}

usage() {
    echo -n 'hyperextensible Vim-based text editor (plugins, theme, etc.)'
    # shellcheck disable=1004
    echo '
                       _
 _ __   ___  _____   _(_)_ __ ___
| |_ \ / _ \/ _ \ \ / / | |_ ` _ \
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|

  '
}

main_apt() {
    return 0
}

main_pacman() {
    require_pip 'nvim-remote'
}

main_brew() {
    require_pip 'nvim-remote'
}

remove_nvim_config() {
    if yes_or_no "neovim" "do you want to remove current neovim configuration?"; then
        msg 'removing current configuration to replace it with new configuration'
        rm -rf "$HOME/.config/nvim"
        return 0
    else
        return 1
    fi
}

main() {
    # Check if nvim config exists
    if [ -e "$HOME/.config/nvim" ]; then
        # If it's a git repository, check if it's the right one
        if [ -d "$HOME/.config/nvim/.git" ]; then
            pushd "$HOME/.config/nvim" >/dev/null || return 1

            url=$(git remote get-url origin 2>/dev/null)
            if [[ "$url" =~ .*github.com[:/]1995parham/elievim ]]; then
                msg 'valid repository, fetching latest changes'
                if ! git pull origin main; then
                    msg 'failed to pull latest changes' 'error'
                    popd >/dev/null || return 1
                fi
                popd >/dev/null || return 1
                lsp_servers

                msg 'syncing neovim plugins with Lazy'
                if ! nvim --headless "+Lazy! sync" +qa; then
                    msg 'failed to sync neovim plugins' 'error'
                    return 1
                fi

                return 0
            else
                msg "invalid repository $url"
                popd >/dev/null || return 1
            fi
        fi

        # Config exists but is not the right repo, ask to remove
        remove_nvim_config || return 1
    fi

    # Clone the repository
    msg 'cloning elievim repository'
    if ! git clone https://github.com/1995parham/elievim "$HOME/.config/nvim"; then
        msg 'failed to clone elievim repository' 'error'
        return 1
    fi

    lsp_servers

    msg 'syncing neovim plugins with Lazy'
    if ! nvim --headless "+Lazy! sync" +qa; then
        msg 'failed to sync neovim plugins' 'error'
        return 1
    fi

    msg 'neovim configuration installed successfully'
}
