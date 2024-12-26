#!/usr/bin/env bash
usage() {
    echo "Wayland is communication protocol that specifies the communication between a display server and its clients."

    # shellcheck disable=1004,2016
    echo '
                     _                 _
__      ____ _ _   _| | __ _ _ __   __| |
\ \ /\ / / _` | | | | |/ _` | |_ \ / _` |
 \ V  V / (_| | |_| | | (_| | | | | (_| |
  \_/\_/ \__,_|\__, |_|\__,_|_| |_|\__,_|
               |___/
  '
}

root=${root:?"root must be set"}

main_apt() {
    return 1
}

main_brew() {
    return 1
}

main_pacman() {
    require_pacman llvm

    msg 'setup waybar'
    require_pacman waybar
    configfile waybar "" wayland

    msg 'install required wayland and xdg packages'
    require_pacman grim xdg-user-dirs wl-clipboard noto-fonts
    require_pacman xdg-utils
    require_pacman xorg-xwayland
    sudo usermod -aG input "$USER"

    msg 'utilities for handling monitors, resolutions, wallpapers and timed wallpapers'
    require_pacman wallutils

    msg 'better sway with more keys [brightnessctl]'
    require_pacman brightnessctl

    msg 'required freedesktop services'
    require_pacman upower rtkit

    msg 'gtk3 theme'
    require_aur matcha-gtk-theme
    configfile gtk-3.0 settings.ini wayland

    msg 'qt support'
    require_pacman qt5-wayland qt6-wayland

    msg 'imv as image viewer (not working with sway-git)'
    require_pacman imv

    msg 'mupdf as pdf viewer'
    require_pacman mupdf

    msg 'notification with dunst'
    require_pacman dunst libnotify
    configfile dunst "" wayland

    # msg 'backgrounds with swaybg'
    # require_pacman swaybg

    msg 'a window switcher, application launcher and dmenu replacement (fork with Wayland support)'
    require_pacman rofi-wayland
    configfile rofi "" wayland

    msg 'we are going to have sound with the awesome pipewire/wireplumber'
    require_pacman pulsemixer easyeffects pavucontrol sof-firmware alsa-ucm-conf

    msg 'configure the dmenu, default application luncher from manjaro i3 days'
    linker dmenu "$root/wayland/dmenurc" "$HOME/.dmenurc"
    chmod +x "$HOME/.dmenurc"

    # msg 'allow run gui application with sudo (e.g. gparted)'
    # xhost +SI:localuser:root

    msg 'gnome-keyring/seahorse setup'
    require_pacman gnome-keyring seahorse

    # some GTK themes contain a dark theme variant,
    # but it is only used by default when the application requests it explicitly.
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark

    # nautilus file manager (a.k.a files)
    # https://wiki.archlinux.org/title/GNOME/Files
    require_pacman ffmpegthumbnailer gst-libav gst-plugins-ugly nautilus

    systemctl --user enable --now gcr-ssh-agent.socket
}

main_parham() {
    msg 'the wallpapers that we love'

    clone https://github.com/parham-alvani/wallpapers "$HOME/Pictures" "GoSiMac"
}
