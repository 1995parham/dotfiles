#!/bin/bash

new_wallpaper="$(find "$HOME/Pictures/GoSiMac" -maxdepth 1 -type f | shuf -n 1)"

swaymsg -s "$SWAYSOCK" output '*' bg "$new_wallpaper" fill
