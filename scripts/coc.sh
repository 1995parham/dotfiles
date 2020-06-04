#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : coc.sh
#
# [] Creation Date : 04-06-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

usage() {
        echo "usage: coc"
}

main() {
        set -o nounset    # error when referencing undefined variable
        set -o errexit    # exit when command fails

        # Install latest nodejs
        if [ ! -x "$(command -v node)" ]; then
                brew install node
        fi

        # Use package feature to install coc.nvim

        mkdir -p ~/.local/share/nvim/site/pack/coc/start
        cd ~/.local/share/nvim/site/pack/coc/start
        curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -

        # Install extensions
        mkdir -p ~/.config/coc/extensions
        cd ~/.config/coc/extensions
        if [ ! -f package.json ]
        then
          echo '{"dependencies":{}}'> package.json
        fi
        # Change extension names to the extensions you need
        npm install coc-go coc-json coc-tsserver coc-git coc-snippets coc-rls coc-python coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
}
