#!/bin/bash

export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

exec sway --unsupported-gpu
