#!/bin/sh

# kill the current swaybg process
pkill swaybg

while true; do
	swaybg -i "$(find "$HOME/Pictures/GoSiMac" -type f -name '*.png' -or -name '*.jpg' -not -name lock.jpg | shuf -n1)" -m fill &
	NEW_PID=$!
	sleep 5
	if [ -n "$OLD_PID" ]; then
		kill "$OLD_PID"
	fi
	OLD_PID=$NEW_PID
	sleep 50
done
