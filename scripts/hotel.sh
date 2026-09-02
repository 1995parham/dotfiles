#!/usr/bin/env bash

usage() {
    echo "pin the Wi-Fi address on a flaky hotel network (macOS only)"
    echo
    echo "hotel DHCP servers often stop answering renewals, which drops the lease and"
    echo "the connection with it. this keeps the leased address as a manual one inside"
    echo "a dedicated 'Hotel' network location, so the 'Automatic' location stays intact."
    echo
    echo "options:"
    echo "  --ip <address>     address to pin (default: the current DHCP lease)"
    echo "  --name <location>  name of the network location (default: Hotel)"
    echo "  --off              switch back to the 'Automatic' location"

    # shellcheck disable=1004,2016
    echo '
 _           _       _
| |__   ___ | |_ ___| |
| |_ \ / _ \| __/ _ \ |
| | | | (_) | ||  __/ |
|_| |_|\___/ \__\___|_|
  '
}

hotel_location="Hotel"
hotel_service="Wi-Fi"
hotel_ip=""
hotel_off=false

pre_main() {
    while [ $# -gt 0 ]; do
        case "$1" in
        --ip)
            hotel_ip="${2:?"--ip needs an address"}"
            shift 2
            ;;
        --name)
            hotel_location="${2:?"--name needs a location name"}"
            shift 2
            ;;
        --off)
            hotel_off=true
            shift
            ;;
        *)
            msg "unknown option: $1" "error"
            return 1
            ;;
        esac
    done
}

hotel_device() {
    networksetup -listallhardwareports |
        awk -v svc="$hotel_service" '$0 == "Hardware Port: " svc { getline; print $2 }'
}

hotel_restore() {
    if [ "$(networksetup -getcurrentlocation)" = "Automatic" ]; then
        msg "already on the 'Automatic' location" "notice"
        return 0
    fi

    sudo networksetup -switchtolocation Automatic >/dev/null
    ok "hotel" "switched back to the 'Automatic' location"
}

main_brew() {
    if ! networksetup -listallnetworkservices | grep -qx "$hotel_service"; then
        msg "network service '$hotel_service' not found" "error"
        return 1
    fi

    if [ "$hotel_off" = true ]; then
        hotel_restore
        return
    fi

    local device
    device=$(hotel_device)
    if [ -z "$device" ]; then
        msg "cannot find the device behind '$hotel_service'" "error"
        return 1
    fi

    local router
    router=$(ipconfig getoption "$device" router 2>/dev/null || true)
    if [ -z "$router" ]; then
        msg "no DHCP router on $device, are you connected?" "error"
        return 1
    fi

    if [ -z "$hotel_ip" ]; then
        hotel_ip=$(ipconfig getifaddr "$device" 2>/dev/null || true)
    fi
    if [ -z "$hotel_ip" ]; then
        msg "no address on $device, pass one with --ip" "error"
        return 1
    fi

    msg "device: $device, address: $hotel_ip, router: $router"

    if ! yes_or_no "hotel" "pin $hotel_ip on '$hotel_service' in the '$hotel_location' location?"; then
        msg "nothing changed" "notice"
        return 0
    fi

    if ! networksetup -listlocations | grep -qx "$hotel_location"; then
        action "hotel" "creating the '$hotel_location' location from the current one"
        sudo networksetup -createlocation "$hotel_location" populate >/dev/null
    fi

    if [ "$(networksetup -getcurrentlocation)" != "$hotel_location" ]; then
        action "hotel" "switching to the '$hotel_location' location"
        sudo networksetup -switchtolocation "$hotel_location" >/dev/null
    fi

    action "hotel" "setting a manual address with DHCP router"
    sudo networksetup -setmanualwithdhcprouter "$hotel_service" "$hotel_ip"

    action "hotel" "setting DNS servers ($router, 1.1.1.1, 8.8.8.8)"
    sudo networksetup -setdnsservers "$hotel_service" "$router" 1.1.1.1 8.8.8.8

    sleep 3
    if ping -c 1 -t 3 "$router" >/dev/null 2>&1; then
        ok "hotel" "$router is reachable from $hotel_ip"
    else
        msg "$router is not reachable, you may need to reconnect to the Wi-Fi" "warn"
    fi

    msg "run './start.sh hotel --off' when you leave the hotel" "notice"
    msg "delete the location afterwards with: sudo networksetup -deletelocation '$hotel_location'" "notice"
}

main() {
    return 0
}
