#!/usr/bin/env bash

usage() {
    echo -n "AWS CLI"
    # shellcheck disable=2016
    echo '

  __ ___      _____
 / _` \ \ /\ / / __|
| (_| |\ V  V /\__ \
 \__,_| \_/\_/ |___/

	'
}

main_pacman() {
    require_pacman aws-vault aws-cli-v2
}

main_brew() {
    require_brew aws-vault awscli lucagrulla/tap/cw aws-cdk
}

main() {
    return 0
}
