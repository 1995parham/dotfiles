#!/usr/bin/env bash

usage() {
    echo "connect and register parham bluetooth devices"

    # shellcheck disable=1004,2016
    echo '
 _     _                         _            _
| |__ | |_   _  ___ ____      __| | _____   _(_) ___ ___  ___
| |_ \| | | | |/ _ \_  /____ / _` |/ _ \ \ / / |/ __/ _ \/ __|
| |_) | | |_| |  __// /_____| (_| |  __/\ V /| | (_|  __/\__ \
|_.__/|_|\__,_|\___/___|     \__,_|\___| \_/ |_|\___\___||___/
  '
}

export dependencies=("bluez")

main_pacman() {
    return 0
}

main_apt() {
    return 1
}

main_brew() {
    return 1
}

main_parham() {
    devices=(
        "galaxy-buds2-pro: Experience studio-worthy listening in our most comfortable design yet."
    )

    local device
    if [ $# -eq 1 ]; then
        device=$("$1" | tr '[:upper:]' '[:lower:]')
    else
        PS3="select device to connect: "

        select device in "${devices[@]}"; do
            device=${device%%:*}
            msg "connecting $device..."
            break
        done
    fi

    local mac_address
    case $device in
    "galaxy-buds2-pro")
        mac_address="64:5D:F4:9E:9D:5F"
        ;;
    *)
        return
        ;;
    esac

    bluetoothctl disconnect "$mac_address" || true
    bluetoothctl untrust "$mac_address" || true
    bluetoothctl remove "$mac_address" || true

    bluetoothctl --timeout 12 scan on

    bluetoothctl info "$mac_address"
    bluetoothctl connect "$mac_address"
    bluetoothctl pair "$mac_address"
    bluetoothctl trust "$mac_address"
}
