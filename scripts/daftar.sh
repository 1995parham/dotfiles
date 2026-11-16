#!/usr/bin/env bash

usage() {
    echo "your vault, natively: https://github.com/parham-alvani/notes-linux"

    # shellcheck disable=1004,2016
    echo '
     _        __ _
  __| | __ _ / _| |_ __ _ _ __
 / _| |/ _| | |_| __/ _| | |__|
| (_| | (_| |  _| || (_| | |
 \__,_|\__,_|_|  \__\__,_|_|

  '
}

# a desktop session runs now or a compositor is installed; a server gets daftar-cli alone.
# graphical.target says nothing: arch boots into it with no desktop at all.
has_desktop() {
    [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]] && return 0
    local compositor
    for compositor in Hyprland sway niri gnome-shell plasmashell Xorg; do
        command -v "${compositor}" &>/dev/null && return 0
    done
    return 1
}

main_pacman() {
    if has_desktop; then
        # the app, with daftar-cli in it
        require_aur daftar-bin
    else
        msg "no desktop, so daftar-cli alone"
        require_aur daftar-cli-bin
    fi
}

main_brew() {
    if [[ "$(uname)" == "Darwin" ]]; then
        require_brew_cask parham-alvani/tap/daftar
    fi
    require_brew parham-alvani/tap/daftar-cli
}

# search by meaning (`daftar-cli search --meaning`, `related`) needs a model run here: 531 MB,
# downloaded once into ~/.cache/daftar/models/. it indexes the vault too, so the vault must be there.
daftar_semantic_model() {
    [[ -n "${daftar_semantic_asked:-}" ]] && return 0
    command -v daftar-cli &>/dev/null || return 0

    if [[ -d "${HOME}/.cache/daftar/models" ]] && [[ -n "$(ls -A "${HOME}/.cache/daftar/models")" ]]; then
        msg "the semantic model is there already" "success"
        daftar_semantic_asked=1
        return 0
    fi

    if [[ ! -d "${HOME}/org" ]]; then
        msg "no vault in ~/org yet, so no semantic model" "notice"
        return 0
    fi

    daftar_semantic_asked=1
    if yes_or_no "daftar" "download the semantic model (531 MB) for search by meaning and index the vault?"; then
        if ! daftar-cli semantic-index --download-model; then
            msg "the semantic model or the index failed, run 'daftar-cli semantic-index --download-model' again" "error"
            return 1
        fi
        msg "the semantic model is there and the vault is indexed" "success"
    else
        msg "no semantic model, search by meaning and related will not work" "notice"
    fi
}

main() {
    # config.toml, init.lua and the home picture, for the mac and the linux app and daftar-cli alike.
    # the whole folder is linked: the apps write config.toml atomically, which replaces a linked file.
    configfile daftar

    daftar_semantic_model
}

main_parham() {
    msg "hello parham, clone your private repositories"

    clone git@github.com:parham-alvani/notes "$HOME" "org"

    # the vault is there only now on a new machine
    daftar_semantic_model
}
