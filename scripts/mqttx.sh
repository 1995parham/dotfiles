#!/usr/bin/env bash

usage() {
    echo "Your All-in-One MQTT Client Toolbox"

    # shellcheck disable=1004,2016
    echo '
                 _   _
 _ __ ___   __ _| |_| |___  __
| |_ ` _ \ / _` | __| __\ \/ /
| | | | | | (_| | |_| |_ >  <
|_| |_| |_|\__, |\__|\__/_/\_\
              |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    current_version="v0.0.0"
    if [ -f "/usr/local/bin/mqttx" ]; then
        current_version=$("/usr/local/bin/mqttx" -v | head -1)
    fi

    next_version="v1.11.0"
    if [ "$(semver_compare "$current_version" "$next_version")" = "lt" ]; then
        curl -LO "https://www.emqx.com/en/downloads/MQTTX/$next_version/mqttx-cli-linux-x64"
        sudo install ./mqttx-cli-linux-x64 /usr/local/bin/mqttx
        rm mqttx-cli-linux-x64
    fi
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew emqx/mqttx/mqttx-cli
}

main() {
    return 0
}

main_parham() {
    return 0
}
