#!/usr/bin/env bash

usage() {
    echo "fonts for terminal, subtitles and more"
    echo '
  __             _
 / _| ___  _ __ | |_
| |_ / _ \| |_ \| __|
|  _| (_) | | | | |_
|_|  \___/|_| |_|\__|

  '
}

main_brew() {
    require_brew_cask \
        font-jetbrains-mono \
        font-jetbrains-mono-nerd-font \
        font-vazirmatn \
        font-dejavu \
        font-fira-code-nerd-font \
        font-fira-code \
        font-roboto
}

_install_font_from_github() {
    local repo=$1
    local font_name=$2
    local release_file=$3

    local font_dir="${HOME}/.local/share/fonts/${font_name}"

    local version
    if ! version=$(_github_release_get_latest_version "${repo}"); then
        return 1
    fi

    local installed_version
    installed_version=$(_github_release_get_installed_version "font-${font_name}")

    if [[ -n "${installed_version}" && "${installed_version}" == "${version}" ]]; then
        running "require" " font ${font_name} ${installed_version} (up to date)"
        return 0
    fi

    action "require" " font ${font_name}"

    local resolved_file
    resolved_file=$(eval echo "${release_file}")

    local temp_dir
    temp_dir=$(mktemp -d)
    local download_url="https://github.com/${repo}/releases/download/${version}/${resolved_file}"

    if ! curl -fsSL -o "${temp_dir}/font.zip" "${download_url}"; then
        message "font" "Failed to download ${font_name}" "error"
        rm -rf "${temp_dir}"
        return 1
    fi

    mkdir -p "${font_dir}"
    unzip -qo "${temp_dir}/font.zip" -d "${font_dir}"
    rm -rf "${temp_dir}"

    _github_release_save_version "font-${font_name}" "${version}"
    message "font" "Installed ${font_name} ${version}" "success"
}

main_apt() {
    require_apt unzip fonts-jetbrains-mono fonts-dejavu fonts-firacode fonts-roboto \
        fonts-noto-color-emoji fonts-font-awesome fonts-noto fonts-liberation2

    _install_font_from_github "ryanoasis/nerd-fonts" "JetBrainsMono" "JetBrainsMono.zip"
    _install_font_from_github "ryanoasis/nerd-fonts" "FiraCode" "FiraCode.zip"
    _install_font_from_github "ryanoasis/nerd-fonts" "Meslo" "Meslo.zip"
    _install_font_from_github "rastikerdar/vazirmatn" "Vazirmatn" 'Vazirmatn-${version}.zip'

    configfile fontconfig
    fc-cache -f
}

main_pacman() {
    require_pacman noto-fonts-emoji ttf-roboto ttf-jetbrains-mono ttf-font-awesome ttf-dejavu noto-fonts \
        otf-font-awesome ttf-liberation ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-firacode-nerd ttf-fira-code
    require_aur vazirmatn-fonts

    configfile fontconfig
    fc-cache -f
}
