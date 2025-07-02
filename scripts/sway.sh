#!/usr/bin/env bash

export additionals=(wayland)

usage() {
    echo "i3-compatible Wayland compositor"
    # shellcheck disable=1004,2028
    echo '
 _____      ____ _ _   _
/ __\ \ /\ / / _| | | | |
\__ \\ V  V / (_| | |_| |
|___/ \_/\_/ \____|\___ |
                   |___/
  '
}

root=${root:?"root must be set"}

main_pacman() {
    msg 'install and configure sway and swaylock'
    if yes_or_no 'sway' 'do you want to use stable release?'; then
        not_require_pacman sway-git swaylock-git wlroots-git swayidle-git swaybg-git sway-git-debug wlroots-git-debug
        require_pacman sway swaylock swayidle swaybg
    else
        not_require_pacman sway swaylock wlroots swayidle swaybg
        require_aur sway-git wlroots-git swaylock-git swayidle-git swaybg-git
    fi

    sudo mkdir -p /etc/pacman.d/hooks || true
    sudo tee /etc/pacman.d/hooks/sway_desktop.hook <<EOL
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = sway

[Action]
Description = Update sway.desktop to use /usr/local/bin/sway.sh.
When = PostTransaction
Exec = /usr/bin/cp $root/archinstall/sway.d/sway.desktop /usr/share/wayland-sessions/sway.desktop
EOL

    copycat "sway" archinstall/sway.d/sway.desktop /usr/share/wayland-sessions/sway.desktop
    copycat "sway" archinstall/sway.d/sway.sh /usr/local/bin/sway.sh

    require_pacman xdg-desktop-portal-wlr wev

    configfile sway "" sway
    configfile swaylock "" sway
    sudo usermod -aG input "$USER"

    msg 'you can install sway-git with wlroots-git in the future'

    msg 'dynamic display configuration'
    require_pacman kanshi
    configfile kanshi "" sway

    msg 'setup user-level systemd services for sway and enable them'
    configsystemd services kanshi.service sway
    configsystemd services workspaces.service sway
    configsystemd services bg.service sway
    configsystemd services swayidle.service sway
    configsystemd services sway-session.target sway
    systemctl --user enable bg.service
    systemctl --user enable kanshi.service
    systemctl --user enable workspaces.service
    systemctl --user enable swayidle.service
}
