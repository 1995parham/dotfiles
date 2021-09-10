#!/bin/bash

pid="$(pidof swaybg)"

new_wallpaper="$(find "$HOME/Pictures/GoSiMac" -maxdepth 1 -type f | shuf -n 1)"

export SWAYSOCK
SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock

swaybg -o '*' -i "$new_wallpaper" -m fill &
sleep 1
kill "$pid"
