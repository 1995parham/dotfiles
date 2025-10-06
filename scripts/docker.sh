#!/usr/bin/env bash

usage() {
    echo "install docker, docker-compose, hadolint etc."

    # shellcheck disable=1004,2016
    echo '
     _            _
  __| | ___   ___| | _____ _ __
 / _` |/ _ \ / __| |/ / _ \ |__|
| (_| | (_) | (__|   <  __/ |
 \__,_|\___/ \___|_|\_\___|_|
  '
}

root=${root:?"root must be set"}

main_apt() {
    sudo apt-get -y update
    sudo apt-get -y install docker.io docker-compose
}

main_xbps() {
    require_xbps docker docker-cli docker-compose crun

    sudo mkdir /etc/docker || true
    sudo touch /etc/docker/daemon.json
    msg 'merge provided configuration with the one that is available on system (delete comments too!)'
    r=$(sed 's/^ *\/\/.*//' <"$root/docker/daemon.json" | jq -s '.[0] * (.[1] // {})' "-" "/etc/docker/daemon.json")
    echo "$r" | sudo tee "/etc/docker/daemon.json"

    msg "manage docker as a non-root user"
    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"

    msg 'docker service with runit'
    if [ ! -L '/etc/runit/runsvdir/default/docker' ]; then
        sudo ln -s /etc/sv/docker /etc/runit/runsvdir/default/
    fi
}

main_brew() {
    require_brew_cask docker
    msg 'please remember to enable docker vmm instead of apple virtualization'
    msg 'dive is working on macOS since docker version 26'
    require_brew lazydocker hadolint docker-completion dive

    msg "Launching Docker Desktop. You may need to grant permissions."
    open /Applications/Docker.app
}

main_pacman() {
    require_pacman docker docker-compose dive docker-buildx crun

    require_aur hadolint-bin lazydocker

    sudo mkdir /etc/docker || true
    sudo touch /etc/docker/daemon.json
    msg 'merge provided configuration with the one that is available on system'
    r=$(sed 's/^ *\/\/.*//' <"$root/docker/daemon.json" | jq -s '.[0] * (.[1] // {})' "-" "/etc/docker/daemon.json")
    echo "$r" | sudo tee "/etc/docker/daemon.json"

    msg 'docker service with systemd'
    sudo systemctl enable --now docker.service

    msg "manage docker as a non-root user"
    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"

    sudo mkdir -p /etc/systemd/system/containerd.service.d/ || true
    echo '
[Service]
LimitNOFILE=1048576
    ' | sudo tee /etc/systemd/system/containerd.service.d/override.conf
    sudo systemctl daemon-reload

    # the following command create a new shell which is not
    # good to run in a script.
    # newgrp docker
}

main() {
    until docker info &>/dev/null; do
        msg "Docker daemon not yet running, waiting..." "error"
        sleep 5
    done

    msg "$(docker version)"

    if command -v gopass &>/dev/null; then
        docker login --username 1995parham --password "$(gopass show -o token/docker/cli)" docker.io
    fi

    if [[ -n $(command -v hadolint) ]]; then
        msg "$(hadolint --version)"
    fi
}
