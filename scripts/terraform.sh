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
    require_pacman terraform opentofu tflint
}

main_brew() {
    require_brew terraform opentofu tflint
}

main_apt() {
    # terraform is not packaged in the default apt repositories, so on
    # Debian/Ubuntu we install OpenTofu only.
    # OpenTofu requires adding the repository
    if ! command -v tofu &>/dev/null; then
        msg "Installing OpenTofu from official repository" "info"

        require_apt ca-certificates curl gnupg

        # the key of the repository (packagecloud) signs its index, which is what apt verifies.
        if ! require_apt_repo opentofu https://packages.opentofu.org/opentofu/tofu/gpgkey \
            https://packages.opentofu.org/opentofu/tofu/any/ any; then
            msg 'failed to add the OpenTofu repository' 'error'
            return 1
        fi

        require_apt tofu
    fi
}

main() {
    msg 'install terraform-ls on neovim'
    require_mason 'terraform-ls'
}
