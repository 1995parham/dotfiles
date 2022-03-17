#!/bin/bash

state=$(swaymsg -t get_inputs -r | jq '.[] | select(.type == "touchpad") | .libinput.send_events' -r)

if [ "$state" == "enabled" ]; then
	echo -n -e "🖰\ntouchpad on"
else
	echo -n -e "🖮\ntouchpad off"
fi
