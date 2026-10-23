#!/usr/bin/env bash
# turn the touchpads on and off, sway's
# swaymsg input type:touchpad events toggle enabled disabled
set -euo pipefail

state="${XDG_RUNTIME_DIR:-/tmp}/hypr-touchpad-disabled"

if [[ -f "$state" ]]; then
    enabled=true
    rm -f "$state"
else
    enabled=false
    touch "$state"
fi

hyprctl devices -j | jq -r '.mice[].name | select(test("touchpad"; "i"))' | while read -r name; do
    hyprctl dispatch "function() hl.device({ name = \"$name\", enabled = $enabled }) end" >/dev/null
done

notify-send -a hyprland -h string:x-canonical-private-synchronous:touchpad "touchpad $([[ $enabled == true ]] && echo enabled || echo disabled)"
