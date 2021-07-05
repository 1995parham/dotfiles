#!/bin/bash

new_wallpaper="$(find "$HOME/Pictures/GoSiMac" -maxdepth 1 -type f | shuf -n 1)"

SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock

swaymsg -s "$SWAYSOCK" output '*' bg "$new_wallpaper" fill
