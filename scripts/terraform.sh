#!/usr/bin/env bash

usage() {
    echo -n -e "terraform and opentofu are infrastructure as code tools that let you define cloud and on-prem resources in human-readable configuration files."

    # shellcheck disable=1004,2016
    echo '
 _                       __
| |_ ___ _ __ _ __ __ _ / _| ___  _ __ _ __ ___
| __/ _ \ |__| |__/ _| | |_ / _ \| |__| |_ | _ \
| ||  __/ |  | | | (_| |  _| (_) | |  | | | | | |
 \__\___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_|
  '
}

main_pacman() {
    require_pacman terraform opentofu
}

main_brew() {
    require_brew terraform opentofu
}

main_apt() {
    require_apt terraform

    # OpenTofu requires adding the repository
    if ! command -v tofu &>/dev/null; then
        msg "Installing OpenTofu from official repository" "info"

        # Install dependencies
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

        # Add OpenTofu GPG key
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
        sudo chmod a+r /etc/apt/keyrings/opentofu.gpg

        # Add repository
        echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" |
            sudo tee /etc/apt/sources.list.d/opentofu.list >/dev/null

        sudo apt-get update
        sudo apt-get install -y tofu
    fi
}

main() {
    msg 'install terraform-ls on neovim'
    require_mason 'terraform-ls'
}
