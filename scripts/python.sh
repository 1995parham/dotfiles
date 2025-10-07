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

    msg 'installing pyenv from official installer'
    local pyenv_installer="/tmp/pyenv-installer.sh"
    if ! curl -fsSL https://pyenv.run -o "$pyenv_installer"; then
        msg 'failed to download pyenv installer' 'error'
        return 1
    fi

    msg 'running pyenv installer'
    if ! bash "$pyenv_installer"; then
        msg 'failed to install pyenv' 'error'
        rm -f "$pyenv_installer"
        return 1
    fi
    rm -f "$pyenv_installer"
}

main_brew() {
    require_brew python pipx pyenv

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

python_install_packages() {
    msg "install user-local packages"
    msg "these packages are generally for dependency management"

    for package in "${packages[@]}"; do
        require_pip "$package"
    done
}

main() {
    if require_country "Iran" &>/dev/null; then
        if yes_or_no "python" "Do you want to use Iranian local python mirror (runflare.com)?"; then
            msg 'configuring pip to use Iranian mirror'
            if ! pip config --user set global.index https://mirror-pypi.runflare.com/simple || \
               ! pip config --user set global.index-url https://mirror-pypi.runflare.com/simple || \
               ! pip config --user set global.trusted-host mirror-pypi.runflare.com; then
                msg 'failed to configure pip mirror' 'error'
                return 1
            fi
            msg 'pip configured to use runflare.com mirror'
        fi
    fi

    python_install_packages

    msg 'pyenv already configured in zsh (zshrc.shared)'
}

main_parham() {
    msg 'setting pypi token on poetry'
    if [[ "$(command -v gopass)" ]]; then
        if ! pipx run poetry config pypi-token.pypi "$(gopass show -o token/pypi/publish)"; then
            msg 'failed to set poetry pypi token' 'error'
            return 1
        fi
        msg 'poetry pypi token configured successfully'
    fi
}
