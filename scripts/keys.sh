#!/bin/bash

usage() {
	echo -n "install public keys as authorized keys ⚠️"
	echo '
 _
| | _____ _   _ ___
| |/ / _ \ | | / __|
|   <  __/ |_| \__ \
|_|\_\___|\__, |___/
          |___/
	'
}

main_pacman() {
	return 0
}

main_apt() {
	return 0
}

main_brew() {
	return 0
}

public() {
	url="https://github.com/$1.keys"

	keys="$(curl -sL "$url")"

	if [ -z "$keys" ]; then
		msg "no keys found for $1" "error"
		return
	fi

	# print the source of information in comment format
	echo | tee -a "$HOME/.ssh/authorized_keys"
	echo "# $url" | tee -a "$HOME/.ssh/authorized_keys"
	echo "$keys" | tee -a "$HOME/.ssh/authorized_keys"
	echo | tee -a "$HOME/.ssh/authorized_keys"
}

main() {
	if [ $# -lt 1 ]; then
		msg "./start.sh keys <username>" "error"
		return
	fi

	public "$1"
}
