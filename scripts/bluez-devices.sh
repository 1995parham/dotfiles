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
    if ! command -v bluetoothctl &>/dev/null; then
        msg 'bluetoothctl not available - please install bluez' 'error'
        return 1
    fi

    devices=(
        "galaxy-buds2-pro: Experience studio-worthy listening in our most comfortable design yet."
    )

    local device
    if [ $# -eq 1 ]; then
        device=$(echo "$1" | tr '[:upper:]' '[:lower:]')
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
        msg "unknown device: $device" 'error'
        return 1
        ;;
    esac

    msg "cleaning up existing connection for $mac_address"
    bluetoothctl disconnect "$mac_address" 2>/dev/null || true
    bluetoothctl untrust "$mac_address" 2>/dev/null || true
    bluetoothctl remove "$mac_address" 2>/dev/null || true

    local scan_timeout=12 # seconds to scan for bluetooth devices
    msg "scanning for bluetooth devices..."
    if ! bluetoothctl --timeout "$scan_timeout" scan on; then
        msg 'bluetooth scan failed' 'error'
        return 1
    fi

    msg "device info:"
    bluetoothctl info "$mac_address"

    msg "connecting to $mac_address"
    if ! bluetoothctl connect "$mac_address"; then
        msg 'failed to connect to device' 'error'
        return 1
    fi

    msg "pairing with device"
    if ! bluetoothctl pair "$mac_address"; then
        msg 'failed to pair with device' 'error'
        return 1
    fi

    msg "trusting device"
    if ! bluetoothctl trust "$mac_address"; then
        msg 'failed to trust device' 'error'
        return 1
    fi

    msg "successfully connected to $device"
}
