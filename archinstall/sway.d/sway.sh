#!/bin/bash

export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export GTK_THEME=Adwaita:dark
export NVD_BACKEND=direct
# to enable wayland on firefox
export MOZ_ENABLE_WAYLAND=1

eval "$(gnome-keyring-daemon --start 2>/dev/null)"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

exec systemd-cat --identifier=sway sway --unsupported-gpu
