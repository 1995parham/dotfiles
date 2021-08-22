#!/bin/bash

walls_dir="$HOME/Pictures/GoSiMac"
selection=$(find "$walls_dir" -type f -name '*.jpg' -o -name '*.png' | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$selection"
