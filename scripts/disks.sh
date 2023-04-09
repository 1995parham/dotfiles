#!/bin/bash

usage() {
	echo -n "disks at your serivce with udev and bash"
	# shellcheck disable=2016
	echo '
     _ _     _
  __| (_)___| | _____
 / _` | / __| |/ / __|
| (_| | \__ \   <\__ \
 \__,_|_|___/_|\_\___/

	'
}

main_pacman() {
	return 0
}

main() {
	copycat "disks" "udev/usb-mount.sh" /usr/local/bin/

	sudo chmod +x /usr/local/bin/usb-mount.sh

	copycat "disks" "udev/73-parham-disks.rules" /etc/udev/rules.d
	copycat "disks" "udev/usb-mount@.service" /etc/systemd/system/

	sudo udevadm control --reload-rules
	sudo systemctl daemon-reload
}
