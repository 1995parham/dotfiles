#!/usr/bin/env bash

packages=(
    # flake8
    # pep8-naming
    # black

    # Pipenv is a production-ready tool that aims to bring the best of all
    # packaging worlds to the Python world.
    pipenv
    # Poetry is a tool for dependency management and packaging in Python.
    poetry
    # PDM, as described, is a modern Python package and dependency manager
    # supporting the latest PEP standards (PEP 582 which is rejected).
    # pdm
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
    if [ ! -d "$HOME/.rye" ]; then
        msg 'a hassle-free python experience'
        curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash
    fi

    msg 'a modern python package and dependency manager supporting the latest pep standards'
    configfile pdm "" python

    python-install-packages

    msg 'pyenv already configured in zsh (zshrc.shared)'
}

main_parham() {
    msg 'setting pypi token on poetry'
    if [[ "$(command -v gopass)" ]]; then
        pipx run poetry config pypi-token.pypi "$(gopass show -o token/pypi/publish)"
    fi
}
