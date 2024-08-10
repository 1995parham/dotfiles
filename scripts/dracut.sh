#!/usr/bin/env bash
usage() {
    echo "dracut is a highly modular tool for generating initramfs images"

    # shellcheck disable=1004,2016
    echo '
     _                      _
  __| |_ __ __ _  ___ _   _| |_
 / _` | |__/ _` |/ __| | | | __|
| (_| | | | (_| | (__| |_| | |_
 \__,_|_|  \__,_|\___|\__,_|\__|
  '
}

main_pacman() {
    require_pacman dracut
    require_not_pacman mkinitcpio

    msg 'install system-wide scripts to generate initramfs'
    copycat dracut dracut/dracut-install.sh /usr/local/bin/dracut-install.sh
    sudo chmod +x /usr/local/bin/dracut-install.sh

    copycat dracut dracut/dracut-remove.sh /usr/local/bin/dracut-remove.sh
    sudo chmod +x /usr/local/bin/dracut-remove.sh

    sudo mkdir -p /etc/pacman.d/hooks || true
    msg 'install pacman hooks for automatic dracut generation'
    copycat dracut dracut/90-dracut-install.hook /etc/pacman.d/hooks/90-dracut-install.hook
    copycat dracut dracut/60-dracut-remove.hook /etc/pacman.d/hooks/60-dracut-remove.hook

    msg 'generate initramfs'
    find '/usr/lib/modules/' -name pkgbase | cut -c2- | sudo /usr/local/bin/dracut-install.sh
}

main_apt() {
    return 1
}

main_brew() {
    return 1
}

main() {
    return 0
}

main_parham() {
    return 0
}
