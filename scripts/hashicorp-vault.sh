#!/usr/bin/env bash

usage() {
    echo "HashiCorp Vault: manage secrets and protect sensitive data"

    # shellcheck disable=1004,2016
    echo '
 _   _           _ _
| | | | __ _ _   _| | |_
| | | |/ _` | | | | | __|
| |_| | (_| | |_| | | |_
 \___/ \__,_|\__,_|_|\__|
  '
}

vault-upstall() {
    msg "installing vault from github releases"

    require_github_release "hashicorp/vault" "vault" "vault_\${version}_linux_amd64" "zip"

    msg "$(vault version 2>/dev/null | head -1)"
}

main_pacman() {
    require_aur vault-bin
}

main_brew() {
    require_brew hashicorp/tap/vault
}

main_apt() {
    # vault is distributed through HashiCorp's own apt repository
    if ! command -v vault &>/dev/null; then
        msg "Installing Vault from HashiCorp repository" "info"

        # Install dependencies
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

        # Add HashiCorp GPG key
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://apt.releases.hashicorp.com/gpg |
            sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
        sudo chmod a+r /etc/apt/keyrings/hashicorp.gpg

        # Add repository
        echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
            sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

        sudo apt-get update
        sudo apt-get install -y vault
    fi
}

main_pkg() {
    vault-upstall
}

main_xbps() {
    vault-upstall
}

main() {
    if command -v vault &>/dev/null; then
        msg "$(vault version 2>/dev/null | head -1) installed" "success"
    fi

    return 0
}
