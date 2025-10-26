#!/usr/bin/env bash

usage() {
    echo "navi cheatsheet"
    echo '
                   _
 _ __   __ ___   _(_)
| |_ \ / _` \ \ / / |
| | | | (_| |\ V /| |
|_| |_|\__,_| \_/ |_|
  '
}

root=${root:?"root must be set"}

main_brew() {
    require_github_release "1995parham/navi" "navi" "navi-\${version}-aarch64-apple-darwin" "tar.gz"
}

main_apt() {
    require_github_release "1995parham/navi" "navi" "navi-\${version}-x86_64-unknown-linux-musl" "tar.gz"
}

main_pacman() {
    require_github_release "1995parham/navi" "navi" "navi-\${version}-x86_64-unknown-linux-musl" "tar.gz"
}

main() {
    linker "navi" "$root/navi/config.toml" "$(navi info config-path)"
}

main_parham() {
    user=1995parham
    repo=cheats
    clone "git@github.com:${user}/${repo}" "$(navi info cheats-path)" "${user}__${repo}"
}

main_elahe() {
    main_parham
}

main_raha() {
    main_parham
}
