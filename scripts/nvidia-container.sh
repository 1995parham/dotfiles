#!/usr/bin/env bash

usage() {
    echo "The NVIDIA Container Toolkit allows users to build and run GPU accelerated containers."

    # shellcheck disable=1004,2016
    echo '
            _     _ _                             _        _
 _ ____   _(_) __| (_) __ _        ___ ___  _ __ | |_ __ _(_)_ __   ___ _ __
| |_ \ \ / / |/ _` | |/ _` |_____ / __/ _ \| |_ \| __/ _` | | |_ \ / _ \ |__|
| | | \ V /| | (_| | | (_| |_____| (_| (_) | | | | || (_| | | | | |  __/ |
|_| |_|\_/ |_|\__,_|_|\__,_|      \___\___/|_| |_|\__\__,_|_|_| |_|\___|_|
  '
}

export dependencies=("docker")

pre_main() {
    return 0
}

main_pacman() {
    require_pacman nvidia-dkms linux-zen-headers nvidia-container-toolkit

    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker
}

main_apt() {
    return 1
}

main_brew() {
    return 1
}

main() {
    if yes_or_no "do you want to try a simple workload with gpu?"; then
        docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
    fi
}

main_parham() {
    return 0
}
