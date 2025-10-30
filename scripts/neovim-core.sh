#!/usr/bin/env bash

usage() {
    echo -n 'hyperextensible Vim-based text editor'
    # shellcheck disable=1004,2016
    echo '
                       _
 _ __   ___  _____   _(_)_ __ ___         ___ ___  _ __ ___
| |_ \ / _ \/ _ \ \ / / | |_ ` _ \ _____ / __/ _ \| |__/ _ \
| | | |  __/ (_) \ V /| | | | | | |_____| (_| (_) | | |  __/
|_| |_|\___|\___/ \_/ |_|_| |_| |_|      \___\___/|_|  \___|
  '
}

pre_main() {
    return 0
}

main_pkg() {
    require_pkg neovim
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
}

main_apt() {
    require_snap nvim --edge --classic
    require_apt python3-pynvim
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
}

main() {
    return 0
}

main_parham() {
    return 0
}
