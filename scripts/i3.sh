#!/usr/bin/env bash

usage() {
    echo "i3 window manager for arch"

    echo '
 _ _____
(_)___ /
| | |_ \
| |___) |
|_|____/
  '
}

export additionals=(x11)

root=${root:?"root must be set"}

main_pacman() {
    msg 'install i3 (actually i3-gaps) with polybar/i3status-rust'
    require_pacman i3-gaps xclip gtk3
    require_aur i3-scrot matcha-gtk-theme polybar i3exit i3status-rust

    configfile gtk-3.0 settings.ini i3
    configfile i3 "" i3
    configfile polybar "" i3
    configfile i3status-rust "" i3

    msg
    msg 'better brightness control with brightnessctl'
    require_pacman brightnessctl

    msg
    msg 'picom is a standalone compositor for Xorg'
    require_pacman picom
    require_pacman unclutter
    configrootfile picom picom.conf i3

    msg
    msg 'notification with dunst'
    require_pacman dunst libnotify
    configfile dunst "" i3

    msg
    msg 'configure the dmenu, default application luncher on i3'
    linker dmenu "$root/i3/dmenurc" "$HOME/.dmenurc"
    chmod +x "$HOME/.dmenurc"

    msg
    msg 'configure rofi another application luncher'
    require_pacman rofi
    configfile rofi "" i3

    msg
    msg 'pavucontrol, a panel for audio'
    require_pacman pavucontrol

    msg
    msg 'pulse-audio tray'
    require_pacman pasystray

    # nautilus file manager (a.k.a files)
    # https://wiki.archlinux.org/title/GNOME/Files
    require_pacman ffmpegthumbnailer gst-libav gst-plugins-ugly nautilus
}
