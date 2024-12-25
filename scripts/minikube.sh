#!/usr/bin/env bash
usage() {
    echo "minikube quickly sets up a local Kubernetes cluster on macOS, Linux, and Windows."

    # shellcheck disable=1004,2016,2028
    echo '
           _       _ _          _
 _ __ ___ (_)_ __ (_) | ___   _| |__   ___
| |_ | _ \| | |_ \| | |/ / | | | |_ \ / _ \
| | | | | | | | | | |   <| |_| | |_) |  __/
|_| |_| |_|_|_| |_|_|_|\_\\__,_|_.__/ \___|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    require_pacman minikube
}

main_brew() {
    require_brew minikube
}

main() {
    minikube config set driver podman
    minikube config set rootless true
}

main_parham() {
    return 0
}
