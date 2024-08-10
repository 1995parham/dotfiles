#!/bin/bash

set -eu
set -o pipefail

usage() {
    echo "Hey queen 👑👋"
    echo "shecan.sh is here to setup shecan for you"
    echo "usage: shecan.sh [-r] [-s] [-h]"
    echo "  -r   reset dns to default"
    echo "  -s   set dns to shecan"
    echo "  -l   list current macOS resolvers"
    echo "  -h   display help"
}

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    source="${BASH_SOURCE[0]}"
fi

root="$(cd "$(dirname "$(realpath "$source")")/../.." && pwd)"

source "$root/scripts/lib/main.sh"
is_queen=false

case "$USER" in
"parham")
    message 'shecan.sh' "Welcome panda 🐼"
    shecan=("178.22.122.101" "185.51.200.1")
    ;;
"elahe")
    message 'shecan.sh' "Welcome queen 👑"
    is_queen=true
    shecan=("178.22.122.101" "185.51.200.1")
    ;;
"raha")
    message 'shecan.sh' "Welcome queen 👑"
    is_queen=true
    shecan=("178.22.122.101" "185.51.200.1")
    ;;
*)
    message 'shecan.sh' "This script is not for you, shu shu"
    exit 1
    ;;
esac

reset=false
setup=false
list=false

domains=(
    "github.com"
    "ipconfig.io"
    "snappcloud.io"
    "staging-snappcloud.io"
    "snapp.tech"
    "snapp.cab"
    "baly.app"
    "shop"
    "home"
    "clientvpn.us-west-2.amazonaws.com"
    "rds.amazonaws.com"
)

while getopts 'rshl' argv; do
    case $argv in
    h)
        usage
        exit
        ;;
    r)
        reset=true
        ;;
    s)
        setup=true
        ;;
    l)
        list=true
        ;;
    *) ;;
    esac
done

# checks you shecan status
http_code=$(curl -s -o /dev/null -w "%{http_code}" -m 10 https://check.shecan.ir || true)
if [ "$http_code" -eq 200 ]; then
    message 'shecan.sh' "you are using shecan"
else
    message 'shecan.sh' "you are not using shecan"
fi

message 'shecan.sh' 'sets or rests shecan DNS in macOS'
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ "$list" = true ]; then
        scutil --dns
    fi
    if [ "$reset" = true ]; then
        message 'shecan.sh' "resets DNS to DHCP defaults"
        networksetup -setdnsservers Wi-Fi empty

        for resolver in "${domains[@]}"; do
            message "shecan.sh" "bypass $resolver from shecan"
            sudo rm "/etc/resolver/$resolver" || true
        done
    fi
    if [ "$setup" = true ]; then
        message 'shecan.sh' 'bypass domains from shecan'
        sudo mkdir '/etc/resolver' || true
        for resolver in "${domains[@]}"; do
            message "shecan.sh" "bypass $resolver from shecan"
            printf "nameserver 8.8.8.8\nnameserver 8.4.4.8\n" | sudo tee "/etc/resolver/$resolver"
        done

        message 'shecan.sh' "sets DNS to shecan ${shecan[*]}"
        networksetup -setdnsservers Wi-Fi "${shecan[@]}"
        if [[ "$is_queen" == true ]]; then
            message 'shecan.sh' 'calls queen ddns on shecan to update her public ip address'
            # curl 'https://ddns.shecan.ir/update?password=b1464f3ac0fe7816'
        fi
    fi
else
    message 'shecan.sh' "this script just works with OSx" 'error'
fi
