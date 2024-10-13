#!/usr/bin/env bash

usage() {
    echo "huggingface_cli is a modern CLI tool that provides an even simpler and more intuitive way to interact with Hugging Face's models, datasets, and other resources."

    # shellcheck disable=1004,2016
    echo '
 _                       _              __
| |__  _   _  __ _  __ _(_)_ __   __ _ / _| __ _  ___ ___
| |_ \| | | |/ _` |/ _` | | |_ \ / _` | |_ / _` |/ __/ _ \
| | | | |_| | (_| | (_| | | | | | (_| |  _| (_| | (_|  __/
|_| |_|\__,_|\__, |\__, |_|_| |_|\__, |_|  \__,_|\___\___|
             |___/ |___/         |___/
  '
}

export dependencies=("python")

pre_main() {
    return 0
}

main_pacman() {
    return 0
}

main_xbps() {
    return 0
}

main_apt() {
    return 0
}

main_brew() {
    return 0
}

main() {
    require_pip huggingface_hub
}

main_parham() {
    return 0
}
