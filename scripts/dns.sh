#!/usr/bin/env bash

usage() {
    echo -n 'my dns, my rules (based on dnsmasq)'
    echo '
     _
  __| |_ __  ___
 / _| | |_ \/ __|
| (_| | | | \__ \
 \__,_|_| |_|___/
  '
}

root=${root:?"root must be set"}

main_pacman() {
    require_pacman dnsmasq

    copycat "dns" "dns/dns.conf" "/etc/NetworkManager/conf.d/dns.conf"
    msg 'NetworkManager will automatically start dnsmasq and add 127.0.0.1 to /etc/resolv.conf'

    copycat "dns" "dns/cache.conf" "/etc/NetworkManager/dnsmasq.d/cache.conf"

    if [ -f "/etc/NetworkManager/dnsmasq.d/shecan.conf" ]; then
        sudo rm '/etc/NetworkManager/dnsmasq.d/shecan.conf'
    fi

    dnsmasq --test --conf-file=/dev/null --conf-dir=/etc/NetworkManager/dnsmasq.d
    sudo nmcli general reload
}
