#!/usr/bin/env bash

usage() {
    echo -n "AWS CLI with required tools like terraform"
    # shellcheck disable=2016
    echo '

  __ ___      _____
 / _` \ \ /\ / / __|
| (_| |\ V  V /\__ \
 \__,_| \_/\_/ |___/

	'
}

main_pacman() {
    require_pacman aws-vault terraform
    require_aur cw-cloudwatch aws-cli-v2
}

main_brew() {
    require_brew aws-vault awscli terraform lucagrulla/tap/cw aws-cdk
}

main() {
    msg 'install terraform-ls on neovim'
    require_mason 'terraform-ls'
}
