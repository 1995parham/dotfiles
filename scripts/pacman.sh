#!/usr/bin/env bash

usage() {
    echo 'pacman configuraiton for arch here and now'

    echo '
 _ __   __ _  ___ _ __ ___   __ _ _ __
| |_ \ / _| |/ __| |_ | _ \ / _| | |_ \
| |_) | (_| | (__| | | | | | (_| | | | |
| .__/ \__,_|\___|_| |_| |_|\__,_|_| |_|
|_|
  '
}

main_pacman() {
    # keeps the running kernel's modules around after a kernel upgrade, so
    # modprobe still works until the next reboot.
    require_pacman kernel-modules-hook

    # CachyOS ships its own pacman.conf (cachyos-* repositories) and makepkg.conf
    # (x86-64-v3 flags), ours would drop its repositories and enable arch testing.
    if grep -qi '^ID=cachyos' /etc/os-release 2>/dev/null; then
        msg 'cachyos manages pacman.conf and makepkg.conf itself, keep them' 'notice'
        return 0
    fi

    copycat "pacman" "pacman/pacman.conf" /etc/pacman.conf
    copycat "pacman" "pacman/makepkg.conf" /etc/makepkg.conf
}
