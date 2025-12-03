#!/usr/bin/env bash

usage() {
    echo "The best free & open source container tools"

    # shellcheck disable=1004,2016
    echo '
                 _
 _ __   ___   __| |_ __ ___   __ _ _ __
| |_ \ / _ \ / _` | |_ ` _ \ / _` | |_ \
| |_) | (_) | (_| | | | | | | (_| | | | |
| .__/ \___/ \__,_|_| |_| |_|\__,_|_| |_|
|_|
  '
}

pre_main() {
    return 0
}

ensure_subid_mappings() {
    local user="${PODMAN_USER:-$USER}"
    local range="${PODMAN_SUBID_RANGE:-100000-165535}"

    if [[ ! -f /etc/subuid || ! -f /etc/subgid ]]; then
        msg 'subuid/subgid files are not available on this system, skipping subordinate ID configuration' 'notice'
        return 0
    fi

    if ! grep -q "^${user}:" /etc/subuid 2>/dev/null; then
        msg "Allocating subordinate UIDs (${range}) for ${user}"
        if ! sudo usermod --add-subuids "${range}" "${user}"; then
            msg 'failed to configure subordinate UIDs' 'error'
        fi
    fi

    if ! grep -q "^${user}:" /etc/subgid 2>/dev/null; then
        msg "Allocating subordinate GIDs (${range}) for ${user}"
        if ! sudo usermod --add-subgids "${range}" "${user}"; then
            msg 'failed to configure subordinate GIDs' 'error'
        fi
    fi
}

configure_storage_driver() {
    local storage_conf="/etc/containers/storage.conf"
    local default_conf="/usr/share/containers/storage.conf"
    local desired_driver="overlay"
    local fs_type=""

    if command -v findmnt &>/dev/null; then
        fs_type=$(findmnt -n -o FSTYPE /var/lib/containers 2>/dev/null || true)
        if [[ "${fs_type}" == "btrfs" ]]; then
            desired_driver="btrfs"
        fi
    fi

    if [[ "${desired_driver}" != "btrfs" ]]; then
        return 0
    fi

    msg 'Detected btrfs backing store. Ensuring Podman uses the btrfs storage driver.'
    if [ ! -f "${storage_conf}" ]; then
        if [ -f "${default_conf}" ]; then
            if ! sudo install -m 644 "${default_conf}" "${storage_conf}"; then
                msg 'failed to copy default storage configuration' 'error'
                return 1
            fi
        else
            if ! printf '[storage]\ndriver = "%s"\n' "${desired_driver}" | sudo tee "${storage_conf}" >/dev/null; then
                msg 'failed to bootstrap storage configuration' 'error'
                return 1
            fi
            return 0
        fi
    fi

    if grep -q '^\s*driver\s*=' "${storage_conf}"; then
        if ! sudo sed -i "s#^\s*driver\s*=.*#driver = \"${desired_driver}\"#" "${storage_conf}"; then
            msg 'failed to update storage driver' 'error'
            return 1
        fi
    else
        if ! printf '\n[storage]\ndriver = "%s"\n' "${desired_driver}" | sudo tee -a "${storage_conf}" >/dev/null; then
            msg 'failed to append storage driver configuration' 'error'
            return 1
        fi
    fi
}

require_apt_if_available() {
    local pkg
    local installable=()

    for pkg in "$@"; do
        if apt-cache show "${pkg}" >/dev/null 2>&1; then
            installable+=("${pkg}")
        else
            msg "apt package ${pkg} is not available in current repositories, skipping" 'notice'
        fi
    done

    if [ ${#installable[@]} -ne 0 ]; then
        require_apt "${installable[@]}"
    fi
}

ensure_podman_machine() {
    local machine="podman-machine-hvf"

    if ! command -v podman &>/dev/null; then
        msg 'podman command is not available, skipping podman machine setup' 'error'
        return 1
    fi

    if ! podman machine ls --format '{{.Name}}' 2>/dev/null | grep -qx "${machine}"; then
        msg "Initializing ${machine} with HVF acceleration"
        if ! podman machine init --cpus 2 --memory 4096 --disk-size 25 --now "${machine}"; then
            msg "failed to initialize ${machine}" 'error'
            return 1
        fi
        return 0
    fi

    local state
    state=$(podman machine inspect "${machine}" --format '{{.State}}' 2>/dev/null || echo "")
    if [[ "${state}" != "running" ]]; then
        msg "Starting ${machine}"
        if ! podman machine start "${machine}"; then
            msg "failed to start ${machine}" 'error'
            return 1
        fi
    fi
}

main_pacman() {
    msg 'According to RedHat, there is a dramatic performance benefit when using CRUN.'
    msg 'The C programming language implements the CRUN container runtime.'
    require_pacman crun

    require_pacman podman
    msg 'Podman depends on the netavark package as the default network backend for rootful containers (see podman-network(1)).'
    require_pacman netavark
    msg 'The optional dependency aardvark-dns is needed for name resolution among containers in the same network.'
    require_pacman aardvark-dns
    msg 'to replace Docker'
    require_pacman podman-compose podman-docker
    require_pacman fuse-overlayfs slirp4netns

    ensure_subid_mappings
    configure_storage_driver
}

main_apt() {
    require_apt crun podman podman-compose podman-docker slirp4netns fuse-overlayfs
    require_apt_if_available netavark aardvark-dns

    ensure_subid_mappings
    configure_storage_driver
}

main_brew() {
    require_brew_cask podman-desktop
    msg 'install podman cli with compose helper because they are used by podman'
    require_brew podman podman-compose

    ensure_podman_machine

    sudo tee /usr/local/bin/docker <<EOF
#!/bin/sh
[ -e /etc/containers/nodocker ] ||
    echo "Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg." >&2
    exec podman "\$@"
EOF
    sudo chmod +x /usr/local/bin/docker

}

main() {
    return 0
}

main_parham() {
    if command -v gopass &>/dev/null; then
        podman login --username 1995parham --password "$(gopass show -o token/docker/cli)" docker.io
    fi
}
