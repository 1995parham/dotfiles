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

packages=(
    tmux
    tmuxp
    htop
    aria2
    curl
    bat
    vim
    jq
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
)

main_apt() {
    apt_packages=(bmon atop jcal)
    declare -A apt_packages_replace=(
        ["dua-cli"]="-"
        ["xh"]="-"
        ["actionlint"]="-"
    )

    sudo apt update -yq

    for package in "${packages[@]}"; do
        if [ "${apt_packages_replace[$package]:-}" ]; then
            package="${apt_packages_replace[$package]}"
        fi

        if [ "$package" != "-" ]; then
            apt_packages+=("$package")
        fi
    done

    msg "install ${apt_packages[*]} with apt"
    require_apt "${apt_packages[@]}"
}

main_xbps() {
    xbps_packages=(
        xmirror
        bind-utils
    )
    declare -A xbps_packages_replace=(
        [lolcat]=lolcat-c
        [tmuxp]=python3-tmuxp
        ["actionlint"]="-"
    )

    for package in "${packages[@]}"; do
        if [ "${xbps_packages_replace[$package]:-}" ]; then
            package="${xbps_packages_replace[$package]}"
        fi

        if [ "$package" != "-" ]; then
            xbps_packages+=("$package")
        fi
    done

    msg "install ${xbps_packages[*]} with xbps"
    require_xbps "${xbps_packages[@]}"
}

main_pkg() {
    pkg_packages=()
    declare -A pkg_packages_replace=(
        [lolcat]="-"
        [tmuxp]="-"
        ["dua-cli"]="dua"
        ["speedtest-cli"]="speedtest-go"
        ["mtr"]="-"
        ["pre-commit"]="-"
        ["actionlint"]="-"
    )

    for package in "${packages[@]}"; do
        if [ "${pkg_packages_replace[$package]:-}" ]; then
            package="${pkg_packages_replace[$package]}"
        fi

        if [ "$package" != "-" ]; then
            pkg_packages+=("$package")
        fi
    done

    msg "install ${pkg_packages[*]} with xbps"
    require_pkg "${pkg_packages[@]}"
}

main_pacman() {
    export allow_no_aur=true

    pacman_packages=(
        perl-image-exiftool
        git-delta
        fd
        jless
        github-cli
        glab
        inetutils
        websocat
        fuse2
        go-yq
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
    declare -A pacman_packages_replace=(
    )

    yay_packages=(
        jcal
        cbonsai
    )
    for package in "${packages[@]}"; do
        if [ "${pacman_packages_replace[$package]:-}" ]; then
            package="${pacman_packages_replace[$package]}"
        fi

        if [ "$package" != "-" ]; then
            pacman_packages+=("$package")
        fi
    done

    msg "install ${pacman_packages[*]} with pacman"
    require_pacman "${pacman_packages[@]}"

    msg "install ${yay_packages[*]} with yay"
    require_aur "${yay_packages[@]}"

    msg 'fix issue with the iptables package'

    if ! pacman -Qi iptables-nft &>/dev/null; then
        sudo pacman --noconfirm --ask=4 -Syu iptables-nft
    fi
}

main_brew() {
    brew_packages=(
        gsed
        coreutils
        inetutils
        inxi
        fontconfig
        git
        bash
        fd
        glab
        jless
        gh
        just
        bat-extras
        wakatime-cli
        jcal
        yq
        watch
        mike-engel/jwt-cli/jwt-cli
        taplo
        xdg-ninja
    )
    for package in "${packages[@]}"; do
        brew_packages+=("$package")
    done

    msg "install ${brew_packages[*]} with brew"
    require_brew "${brew_packages[@]}"

    brew_cask_packages=(
        muzzle
        the-unarchiver
        KeepingYouAwake
        maccy
        pearcleaner
    )

    msg "install ${brew_cask_packages[*]} with brew --cask"
    require_brew_cask "${brew_cask_packages[@]}"
}
