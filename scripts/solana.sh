#!/usr/bin/env bash
usage() {
    echo "Solana is a high-performance blockchain platform designed for fast, scalable, and low-cost decentralized applications (dApps) using a unique Proof of History (PoH) consensus mechanism combined with Proof of Stake (PoS)."

    # shellcheck disable=1004,2016
    echo '
           _
 ___  ___ | | __ _ _ __   __ _
/ __|/ _ \| |/ _` | |_ \ / _` |
\__ \ (_) | | (_| | | | | (_| |
|___/\___/|_|\__,_|_| |_|\__,_|
  '
}

export dependencies=("rust")

pre_main() {
    return 0
}

main_pacman() {
    require_aur solana
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    require_brew solana
}

main() {
    msg 'Install Anchor framework using Anchor Version Manager (AVM)'
    cargo install --git https://github.com/coral-xyz/anchor avm --force
}

main_parham() {
    return 0
}
