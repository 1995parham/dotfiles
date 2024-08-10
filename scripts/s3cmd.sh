#!/usr/bin/env bash

usage() {
    echo "Command line tool for managing S3 compatible storage services (including Amazon S3 and CloudFront)"

    # shellcheck disable=1004,2016
    echo '
     _____                    _
 ___|___ /  ___ _ __ ___   __| |
/ __| |_ \ / __| |_ ` _ \ / _` |
\__ \___) | (__| | | | | | (_| |
|___/____/ \___|_| |_| |_|\__,_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman s3cmd
}

main_apt() {
    return 1
}

main_brew() {
    require_brew s3cmd
}

main() {
    return 0
}

main_parham() {
    return 0
}
