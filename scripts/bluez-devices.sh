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
		"wh-1000xm5: WH-1000XM5 Wireless Noise Cancelling Headphones, YOUR WORLD. NOTHING ELSE."
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

	case $device in
	"wh-1000xm5")
		bluetoothctl connect 'AC:80:0A:0D:A3:AB'
		bluetoothctl trust 'AC:80:0A:0D:A3:AB'
		bluetoothctl info 'AC:80:0A:0D:A3:AB'
		;;
	esac
}
