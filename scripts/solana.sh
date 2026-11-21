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

main_pacman() {
    require_aur solana
}

main_brew() {
    require_brew solana
}

main() {
    # no package has avm, so cargo builds it. without the check (and with --force) each run
    # compiled it again.
    if command -v avm &>/dev/null; then
        msg "avm is already installed: $(avm --version)"
        return 0
    fi

    msg 'Install Anchor framework using Anchor Version Manager (AVM)'
    cargo install --git https://github.com/coral-xyz/anchor avm
}
