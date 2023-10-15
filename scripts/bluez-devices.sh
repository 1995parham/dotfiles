#!/bin/bash
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
		"wh-1000xm5-parham: WH-1000XM5 Wireless Noise Cancelling Headphones, YOUR WORLD. NOTHING ELSE. 🐼"
		"wh-1000xm5-elahe: WH-1000XM5 Wireless Noise Cancelling Headphones, YOUR WORLD. NOTHING ELSE. 🌰"
		"redmi-buds-3-pro: 35dB Smart noise cancellation | Dual-device connectivity | Wireless charging | 28h long battery life, The sound you want"
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
	"wh-1000xm5-parham")
		mac_address="AC:80:0A:45:A3:1F"
		;;
	"wh-1000xm5-elahe")
		mac_address="AC:80:0A:0D:A3:AB"
		;;
	"redmi-buds-3-pro")
		mac_address="6C:D3:EE:28:D8:A5"
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
