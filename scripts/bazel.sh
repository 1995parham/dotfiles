#!/usr/bin/env bash

readonly BAZELISK_INFO='Bazelisk is a wrapper for Bazel written in Go. It automatically picks a good version of Bazel given your current working directory, downloads it from the official server (if required) and then transparently passes through all command-line arguments to the real Bazel binary. You can call it just like you would call Bazel.'

usage() {
    echo "a fast, scalable, multi-language and extensible build system"

    # shellcheck disable=1004,2016
    echo '
 _                   _
| |__   __ _ _______| |
| |_ \ / _` |_  / _ \ |
| |_) | (_| |/ /  __/ |
|_.__/ \__,_/___\___|_|
  '
}

main_pacman() {
    msg "$BAZELISK_INFO"
    require_aur bazelisk
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
    msg "$BAZELISK_INFO"
    require_brew bazelisk
}

main() {
    require_go github.com/bazelbuild/buildtools/buildifier
}
