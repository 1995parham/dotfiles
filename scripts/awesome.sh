#!/usr/bin/env bash

usage() {
    echo "awesome is a highly configurable, next generation framework window manager for X"

    echo '
  __ ___      _____  ___  ___  _ __ ___   ___
 / _` \ \ /\ / / _ \/ __|/ _ \| |_ | _ \ / _ \
| (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/
 \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|
  '
}

export additionals=(x11)

root=${root:?"root must be set"}

main_pacman() {
    configfile awesome "" awesome

    msg 'install awesome with required system tooling'
    require_pacman awesome picom redshift unclutter xfce4-power-manager acpi pamixer xorg xorg-apps
    require_aur i3exit matcha-gtk-theme

    msg 'configure rofi another application launcher'
    require_pacman rofi
    configfile rofi "" awesome

    require_pacman scrot
}
