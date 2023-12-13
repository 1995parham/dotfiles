#!/usr/bin/env bash

function _serial_number() {
	serial="none"

	if [[ "$OSTYPE" == "darwin"* ]]; then
		serial="$(ioreg -l | grep IOPlatformSerialNumber | cut -d= -f2 | tr -d '"' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\n')"
	else
		if [[ "$(command -v dmidecode)" ]]; then
			serial="$(sudo dmidecode -s system-serial-number)"
		fi
	fi

	echo "$serial"
}
