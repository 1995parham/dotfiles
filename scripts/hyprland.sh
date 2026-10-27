#!/usr/bin/env bash
usage() {
    echo "dynamic tiling Wayland compositor, configured to match our sway on top of the noctalia shell"

    # shellcheck disable=1004,2016
    echo '
 _                      _                 _
| |__  _   _ _ __  _ __| | __ _ _ __   __| |
| |_ \| | | | |_ \| |__| |/ _` | |_ \ / _` |
| | | | |_| | |_) | |  | | (_| | | | | (_| |
|_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
       |___/|_|
  '
}

root=${root:?"root must be set"}

main_pacman() {
    msg 'hyprland under uwsm, with the noctalia shell (bar, launcher, notifications, lock, idle)'
    require_pacman hyprland uwsm xdg-desktop-portal-hyprland hyprpicker qt5-wayland qt6-wayland

    # cachyos ships noctalia in its repositories, arch has it on the aur
    if pacman -Si noctalia >/dev/null 2>&1; then
        require_pacman noctalia
    else
        require_aur noctalia-shell
    fi

    msg 'tools the key bindings and the bar widgets call (socat for the hypr-submap plugin)'
    require_pacman alacritty grim jq xdg-user-dirs libnotify pavucontrol brightnessctl bat socat
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    return 1
}

main() {
    configfile hypr "" hyprland
    configfile noctalia "" hyprland
    configfile uwsm "" hyprland

    # caffeine (~/bin/caffeine, from bin/) in the launcher: keeps the screen awake
    mkdir -p "$HOME/.local/share/applications"
    linker hyprland "${root}/hyprland/applications/caffeine.desktop" "$HOME/.local/share/applications/caffeine.desktop"

    # noctalia/wallpaper.toml rotates ~/Pictures/Barcelona and locks on its
    # lock.jpg; the pictures are ~110 MB of Commons originals, so they are
    # fetched rather than kept here.
    if [[ ! -f "$HOME/Pictures/Barcelona/lock.jpg" ]]; then
        bash "${root}/wallpapers/barcelona.sh"
    fi

    msg 'hyprland reloads its configuration on change, run hyprctl configerrors to check it'
    msg 'noctalia fetches the community plugins of noctalia/plugins.toml itself, restart it once they are in'
}
