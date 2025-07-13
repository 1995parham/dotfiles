#!/usr/bin/env bash

packages=(
    # An extremely fast Python package and project manager, written in Rust.
    uv
    # Pipenv is a production-ready tool that aims to bring the best of all
    # packaging worlds to the Python world.
    pipenv
    # Poetry is a tool for dependency management and packaging in Python.
    poetry
)

usage() {
    echo -n "python with useful tools for science and phd"
    # shellcheck disable=1004
    echo '
             _   _
 _ __  _   _| |_| |__   ___  _ __
| |_ \| | | | __| |_ \ / _ \| |_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/

  '
}

main_apt() {
    require_apt pipx

    curl https://pyenv.run | bash
}

main_brew() {
    require_brew python pipx pyenv python

    msg 'GDAL is a translator library for raster and vector geospatial data formats'
    require_brew gdal
}

main_pacman() {
    require_pacman python python-pip python-pipx pyenv

    msg 'GDAL is a translator library for raster and vector geospatial data formats'
    require_pacman gdal

    msg 'MySQL/MariaDB client library'
    require_pacman mariadb-clients
}

python-install-packages() {
    msg "install user-local packages"
    msg "these package generally are there for dependency management"

    for package in "${packages[@]}"; do
        require_pip "$package"
    done
}

main() {
    if require_country "Iran" &>/dev/null; then
        if yes_or_no "Do you want to use Iranian local python mirror (runflare.com)"; then
            pip config --user set global.index https://mirror-pypi.runflare.com/simple
            pip config --user set global.index-url https://mirror-pypi.runflare.com/simple
            pip config --user set global.trusted-host mirror-pypi.runflare.com
        fi
    fi

    python-install-packages

    msg 'pyenv already configured in zsh (zshrc.shared)'
}

main_parham() {
    msg 'setting pypi token on poetry'
    if [[ "$(command -v gopass)" ]]; then
        pipx run poetry config pypi-token.pypi "$(gopass show -o token/pypi/publish)"
    fi
}
