#!/usr/bin/env bash

usage() {
    echo -n "installs required packages for having a working system"
    echo '
  ___ _ ____   __
 / _ \ |_ \ \ / /
|  __/ | | \ V /
 \___|_| |_|\_/

  '
}

export dependencies=("fetch" "zsh" "bash")

# Common packages across all package managers
packages=(
    tmux
    tmuxp
    htop
    aria2
    curl
    bat
    vim
    jq
    bfs
    fzf
    mosh
    figlet
    lolcat
    dua-cli
    wget
    actionlint
    chafa
    ripgrep
    speedtest-cli
    whois
    xh
    rsync
    pre-commit
    mtr
    tree
    git
    bash
    fd
    jless
    yq
)

# Apply package name replacements for a specific package manager
# Populates the result_array_name with transformed packages
# Usage: apply_package_replacements result_array_name "replacement_map_declaration" package1 package2 ...
apply_package_replacements() {
    local result_array_name="$1"
    local replacement_decl="$2"
    shift 2
    local base_packages=("$@")

    # Declare the associative array from the string
    eval "declare -A replacement_map=${replacement_decl}"

    local result=()
    for package in "${base_packages[@]}"; do
        local mapped_package="${replacement_map[$package]:-$package}"

        # Skip packages mapped to "-" (not available for this package manager)
        if [ "$mapped_package" != "-" ]; then
            result+=("$mapped_package")
        fi
    done

    # Use eval to assign the array to the variable name
    eval "$result_array_name=(\"\${result[@]}\")"
}

main_apt() {
    local apt_specific=(bmon atop jcal)
    local apt_replace='(
        ["dua-cli"]="-"
        ["xh"]="-"
        ["actionlint"]="-"
        ["yq"]="yq"
        ["watch"]="procps"
        ["fd"]="fd-find"
        ["jless"]="-"
    )'

    if ! sudo apt update -yq; then
        msg 'failed to update apt package list' 'error'
        return 1
    fi

    local apt_common=()
    apply_package_replacements apt_common "$apt_replace" "${packages[@]}"

    local apt_packages=(
        "${apt_specific[@]}"
        "${apt_common[@]}"
    )

    msg "install ${apt_packages[*]} with apt"
    require_apt "${apt_packages[@]}"
}

main_xbps() {
    local xbps_specific=(xmirror bind-utils)
    local xbps_replace='(
        [lolcat]="lolcat-c"
        [tmuxp]="python3-tmuxp"
        ["actionlint"]="-"
    )'

    local xbps_common=()
    apply_package_replacements xbps_common "$xbps_replace" "${packages[@]}"

    local xbps_packages=(
        "${xbps_specific[@]}"
        "${xbps_common[@]}"
    )

    msg "install ${xbps_packages[*]} with xbps"
    require_xbps "${xbps_packages[@]}"
}

main_pkg() {
    local pkg_specific=()
    local pkg_replace='(
        [lolcat]="-"
        [tmuxp]="-"
        ["dua-cli"]="dua"
        ["speedtest-cli"]="speedtest-go"
        ["mtr"]="-"
        ["pre-commit"]="-"
        ["actionlint"]="-"
    )'

    local pkg_common=()
    apply_package_replacements pkg_common "$pkg_replace" "${packages[@]}"

    local pkg_packages=(
        "${pkg_specific[@]}"
        "${pkg_common[@]}"
    )

    msg "install ${pkg_packages[*]} with pkg"
    require_pkg "${pkg_packages[@]}"
}

main_pacman() {
    export allow_no_aur=true

    local pacman_specific=(
        perl-image-exiftool
        git-delta
        github-cli
        glab
        inetutils
        websocat
        fuse2
        man-pages
        usbutils
        exfat-utils
        openbsd-netcat
        cpupower
        reflector
        jwt-cli
        tokei
        glow
        arch-wiki-lite
        arch-wiki-docs
        pastel
        man-db
        bandwhich
        lsof
        vhs
        just
        bat-extras
        tcpdump
        powertop
        taplo-cli
        bind
    )
    local yay_packages=(jcal cbonsai)
    local pacman_replace='(
        [yq]="go-yq"
    )'

    local pacman_common=()
    apply_package_replacements pacman_common "$pacman_replace" "${packages[@]}"

    local pacman_packages=(
        "${pacman_specific[@]}"
        "${pacman_common[@]}"
    )

    msg "install ${pacman_packages[*]} with pacman"
    require_pacman "${pacman_packages[@]}"

    msg "install ${yay_packages[*]} with yay"
    require_aur "${yay_packages[@]}"

    msg 'fix issue with the iptables package'
    if ! pacman -Qi iptables-nft &>/dev/null; then
        if ! sudo pacman --noconfirm --ask=4 -Syu iptables-nft; then
            msg 'failed to install iptables-nft' 'error'
            return 1
        fi
    fi
}

main_brew() {
    local brew_specific=(
        gsed
        coreutils
        inetutils
        inxi
        fontconfig
        glab
        gh
        just
        bat-extras
        wakatime-cli
        jcal
        mike-engel/jwt-cli/jwt-cli
        taplo
        xdg-ninja
        watch
    )
    local brew_cask_packages=(
        muzzle
        the-unarchiver
        KeepingYouAwake
        maccy
        pearcleaner
    )
    local brew_replace='()'

    local brew_common=()
    apply_package_replacements brew_common "$brew_replace" "${packages[@]}"

    local brew_packages=(
        "${brew_specific[@]}"
        "${brew_common[@]}"
    )

    msg "install ${brew_packages[*]} with brew"
    require_brew "${brew_packages[@]}"

    msg "install ${brew_cask_packages[*]} with brew --cask"
    require_brew_cask "${brew_cask_packages[@]}"
}
