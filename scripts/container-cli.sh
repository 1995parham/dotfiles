#!/usr/bin/env bash

usage() {
    echo "engine-agnostic container CLI tools (docker CLI, compose, buildx, lazydocker, hadolint, dive, crane)"

    # shellcheck disable=1004,2016
    echo '
                  _        _                          _ _
  ___ ___  _ __ | |_ __ _(_)_ __   ___ _ __        __| (_)
 / __/ _ \| |_ \| __/ _` | | |_ \ / _ \ |__|_____ / _` | |
| (_| (_) | | | | || (_| | | | | |  __/ |  |_____| (_| | |
 \___\___/|_| |_|\__\__,_|_|_| |_|\___|_|         \__,_|_|
  '
}

root=${root:?"root must be set"}

main_brew() {
    msg 'install Docker CLI and plugins (engine-agnostic)'
    require_brew docker docker-compose docker-buildx docker-credential-helper docker-completion

    msg 'install container introspection and quality tools'
    require_brew lazydocker hadolint dive crane
}

main_pacman() {
    msg 'install cross-engine container tools'
    require_pacman dive crane
    require_aur hadolint-bin lazydocker
}

main_apt() {
    require_apt curl ca-certificates

    require_github_release "google/go-containerregistry" "crane" "go-containerregistry_Linux_x86_64" "tar.gz"
    require_github_release "wagoodman/dive" "dive" "dive_\${version#v}_linux_amd64" "tar.gz"
    require_github_release "hadolint/hadolint" "hadolint" "hadolint-Linux-x86_64"
    require_github_release "jesseduffield/lazydocker" "lazydocker" "lazydocker_\${version#v}_Linux_x86_64" "tar.gz"
}

main() {
    if command -v docker &>/dev/null; then
        msg "$(docker --version 2>/dev/null || echo 'docker CLI installed')"
    fi
    if command -v hadolint &>/dev/null; then
        msg "$(hadolint --version)"
    fi
    if command -v crane &>/dev/null; then
        msg "$(crane version 2>/dev/null || echo 'crane installed')"
    fi
}
