#!/usr/bin/env bash

export additionals=("node" "go" "python" "shell" "java")

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

pre_main() {
    return 0
}

main_pkg() {
    require_pkg neovim
}

main_apt() {
    require_snap nvim --edge --classic
    require_apt python3-pynvim
}

main_pacman() {
    if yes_or_no 'neovim' 'do you want to use stable release?'; then
        not_require_pacman neovim-git
        require_pacman neovim
    else
        not_require_pacman neovim
        # rm -rf ~/.cache/yay/neovim-git || true
        require_aur neovim-git
    fi
    require_pacman libvterm python-pynvim luarocks stylua
    require_pip 'nvim-remote'
}

main_brew() {
    if yes_or_no 'neovim' 'do you want to use stable release?'; then
        brew list --version neovim | grep HEAD && brew uninstall --ignore-dependencies neovim
        require_brew neovim
    else
        brew list --version neovim | grep HEAD || brew uninstall --ignore-dependencies neovim
        require_brew_head neovim
    fi
    require_brew luarocks gcc@11 stylua
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

# Clone or update elievim configuration repository
require_elievim_repo() {
    local repo_url="https://github.com/1995parham/elievim"
    local config_dir="$HOME/.config/nvim"

    running "require" " elievim configuration"

    # Check if nvim config exists
    if [ -e "$config_dir" ]; then
        # If it's a git repository, check if it's the right one
        if [ -d "$config_dir/.git" ]; then
            pushd "$config_dir" >/dev/null || return 1

            local url
            url=$(git remote get-url origin 2>/dev/null)
            if [[ "$url" =~ .*github.com[:/]1995parham/elievim ]]; then
                action "require" " pulling latest changes from elievim"
                if ! git pull origin main; then
                    message "elievim" "failed to pull latest changes" "error"
                    popd >/dev/null || return 1
                fi
                popd >/dev/null || return 1
                return 0
            else
                message "elievim" "invalid repository $url" "warn"
                popd >/dev/null || return 1
            fi
        fi

        # Config exists but is not the right repo, ask to remove
        remove_nvim_config || return 1
    fi

    # Clone the repository
    action "require" " cloning elievim repository"
    if ! git clone "$repo_url" "$config_dir"; then
        message "elievim" "failed to clone elievim repository" "error"
        return 1
    fi

    return 0
}

main() {
    # Only install elievim configuration if requested
    if yes_or_no "neovim" "do you want to install elievim configuration (full setup)?"; then
        require_elievim_repo || return 1
        lsp_servers

        msg 'syncing neovim plugins with Lazy'
        if ! nvim --headless "+Lazy! sync" +qa; then
            msg 'failed to sync neovim plugins' 'error'
            return 1
        fi

        msg 'neovim configuration installed successfully'
    else
        msg 'neovim core installed (minimal setup)'
    fi
}

main_parham() {
    return 0
}
