#!/usr/bin/env bash

usage() {
    echo "enabling two factor authentication for using ssh"

    # shellcheck disable=1004,2016
    echo '
         _          ____   __
 ___ ___| |__      |___ \ / _| __ _
/ __/ __| |_ \ _____ __) | |_ / _` |
\__ \__ \ | | |_____/ __/|  _| (_| |
|___/___/_| |_|    |_____|_|  \__,_|
  '
}

export dependencies=("qr")

main_pacman() {
    require_pacman libpam-google-authenticator

    echo "
PasswordAuthentication no
KbdInteractiveAuthentication yes
AuthenticationMethods publickey,keyboard-interactive:pam
" | sudo tee "/etc/ssh/sshd_config.d/20-pam.conf" >/dev/null

    # /etc/pam.d/sshd ships with the distro; back it up once before we
    # replace it so a broken 2fa stack can be restored (and so re-runs
    # don't clobber a backup that captured distro updates).
    if [ ! -f /etc/pam.d/sshd.dotfiles.bak ]; then
        sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.dotfiles.bak
    fi

    echo "
#%PAM-1.0

auth required pam_google_authenticator.so
#auth      include   system-remote-login
account   include   system-remote-login
password  include   system-remote-login
session   include   system-remote-login
" | sudo tee "/etc/pam.d/sshd" >/dev/null
}

main() {
    if [ ! -f "$HOME/.google_authenticator" ]; then
        # only continue if enrollment actually succeeded — otherwise a
        # restart below would enforce a 2fa stack with no configured token.
        if ! google-authenticator -t -d -r 3 -R 60; then
            msg "google-authenticator enrollment failed; not touching sshd" "error"
            return 1
        fi
    fi

    # never restart sshd with a config it can't parse — on a remote host
    # that can lock you out.
    if ! sudo sshd -t; then
        msg "sshd config is invalid; refusing to restart sshd" "error"
        msg "restore /etc/pam.d/sshd.dotfiles.bak if needed" "notice"
        return 1
    fi

    sudo systemctl restart sshd.service
}
