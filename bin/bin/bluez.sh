#!/bin/bash

echo 'bluetooth devices per system that I have'

case "$HOSTNAME" in
"parham-y9000k")
	echo "SRS-XB13:"
	bluetoothctl info 6C:47:60:82:BD:A6
	echo "Redmi Buds 3 Pro:"
	bluetoothctl info 6C:D3:EE:28:D8:A5
	;;
esac
