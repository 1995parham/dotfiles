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

configure_docker_daemon() {
    if [ ! -f "$root/docker/daemon.json" ]; then
        msg 'docker daemon.json config file not found, skipping configuration' 'error'
        return 1
    fi

    sudo mkdir -p /etc/docker || true
    sudo touch /etc/docker/daemon.json

    msg 'merge provided configuration with the one that is available on system'
    local merged_config
    if ! merged_config=$(sed 's/^ *\/\/.*//' <"$root/docker/daemon.json" | jq -s '.[0] * (.[1] // {})' "-" "/etc/docker/daemon.json"); then
        msg 'failed to merge docker daemon configuration' 'error'
        return 1
    fi

    if ! echo "$merged_config" | sudo tee "/etc/docker/daemon.json" >/dev/null; then
        msg 'failed to write docker daemon configuration' 'error'
        return 1
    fi
}

setup_docker_user() {
    msg "manage docker as a non-root user"
    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"
}

main_apt() {
    require_apt docker.io docker-compose
}

main_xbps() {
    require_xbps docker docker-cli docker-compose crun

    configure_docker_daemon || return 1
    setup_docker_user

    msg 'docker service with runit'
    if [ ! -L '/etc/runit/runsvdir/default/docker' ]; then
        if ! sudo ln -s /etc/sv/docker /etc/runit/runsvdir/default/; then
            msg 'failed to enable docker service with runit' 'error'
            return 1
        fi
    fi
}

main_brew() {
    require_brew_cask docker
    require_brew lazydocker hadolint docker-completion dive

    if [ -d "/Applications/Docker.app" ]; then
        msg "Launching Docker Desktop. You may need to grant permissions."
        if ! open /Applications/Docker.app; then
            msg 'failed to launch Docker Desktop' 'error'
            return 1
        fi
    else
        msg 'Docker Desktop not found at /Applications/Docker.app' 'error'
        return 1
    fi
}

main_pacman() {
    require_pacman docker docker-compose dive docker-buildx crun
    require_aur hadolint-bin lazydocker

    configure_docker_daemon || return 1

    msg 'docker service with systemd'
    if ! sudo systemctl enable --now docker.service; then
        msg 'failed to enable docker service' 'error'
        return 1
    fi

    setup_docker_user

    sudo mkdir -p /etc/systemd/system/containerd.service.d/ || true
    if ! echo '[Service]
LimitNOFILE=1048576' | sudo tee /etc/systemd/system/containerd.service.d/override.conf >/dev/null; then
        msg 'failed to configure containerd service' 'error'
        return 1
    fi

    if ! sudo systemctl daemon-reload; then
        msg 'failed to reload systemd daemon' 'error'
        return 1
    fi
}

main() {
    local timeout=60
    local elapsed=0
    until sg 'docker' -c 'docker info' &>/dev/null; do
        if [ $elapsed -ge $timeout ]; then
            msg "Docker daemon did not start within ${timeout} seconds" "error"
            return 1
        fi
        msg "Docker daemon not yet running, waiting... ($elapsed/${timeout}s)"
        sleep 5
        elapsed=$((elapsed + 5))
    done

    msg "$(docker version)"

    if command -v hadolint &>/dev/null; then
        msg "$(hadolint --version)"
    fi
}

main_parham() {
    if command -v gopass &>/dev/null; then
        msg 'logging into Docker Hub'
        if ! docker login --username 1995parham --password "$(gopass show -o token/docker/cli)" docker.io; then
            msg 'failed to login to Docker Hub' 'error'
            return 1
        fi
    fi
}
