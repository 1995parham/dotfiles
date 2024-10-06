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

# neovim right now has very high cpu/memory usage and it is not suitable
# for every system.
# export dependencies=("neovim")
export dependencies=("fetch" "zsh" "bash")

packages=(tmux htop aria2 curl bat vim jq fzf mosh figlet lolcat dua-cli wget chafa)

xbps_packages=()
declare -A xbps_packages_replace=(
    [lolcat]=lolcat-c
)

brew_packages=(
    coreutils
    inetutils
    inxi
    fontconfig
    tmuxp
    git
    bash
    ripgrep
    fd
    glab
    jless
    gh
    just
    bat-extras
    wakatime-cli
    muzzle
    jcal
    teamookla/speedtest/speedtest
    mtr
    yq
    watch
    mike-engel/jwt-cli/jwt-cli
    taplo
    actionlint
    xdg-ninja
    the-unarchiver
)
declare -A brew_packages_replace=(
)

apt_packages=(bmon atop jcal)
declare -A apt_packages_replace=(
    ["dua-cli"]=""
)

pacman_packages=(
    perl-image-exiftool
    ripgrep
    mtr
    git-delta
    fd
    jless
    github-cli glab
    inetutils websocat fuse2
    go-yq man-pages usbutils exfat-utils
    openbsd-netcat
    cpupower
    reflector
    jwt-cli
    tokei
    glow
    tmuxp
    arch-wiki-lite arch-wiki-docs
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
)
declare -A pacman_packages_replace=(
)

yay_packages=(
    jcal
    actionlint-bin
    cbonsai
    ookla-speedtest-bin
)

main_apt() {
    sudo apt update -yq

    for package in "${packages[@]}"; do
        if [ "${apt_packages_replace[$package]:-}" ]; then
            package="${apt_packages_replace[$package]}"
        fi

        if [ -n "$package" ]; then
            apt_packages+=("$package")
        fi
    done

    msg "install ${apt_packages[*]} with apt"
    require_apt "${apt_packages[@]}"
}

main_xbps() {
    for package in "${packages[@]}"; do
        if [ "${xbps_packages_replace[$package]:-}" ]; then
            package="${xbps_packages_replace[$package]}"
        fi

        if [ -n "$package" ]; then
            xbps_packages+=("$package")
        fi
    done

    msg "install ${xbps_packages[*]} with xbps"
    require_xbps "${xbps_packages[@]}"
}

main_pacman() {
    for package in "${packages[@]}"; do
        if [ "${pacman_packages_replace[$package]:-}" ]; then
            package="${pacman_packages_replace[$package]}"
        fi

        if [ -n "$package" ]; then
            pacman_packages+=("$package")
        fi
    done

    msg "install ${pacman_packages[*]} with pacman"
    require_pacman "${pacman_packages[@]}"

    msg "install ${yay_packages[*]} with yay"
    require_aur "${yay_packages[@]}"
}

main_brew() {
    for package in "${packages[@]}"; do
        if [ "${brew_packages_replace[$package]:-}" ]; then
            package="${brew_packages_replace[$package]}"
        fi

        if [ -n "$package" ]; then
            brew_packages+=("$package")
        fi
    done

    msg "install ${brew_packages[*]} with brew"
    require_brew "${brew_packages[@]}"
}
