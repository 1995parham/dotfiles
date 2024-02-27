#!/bin/bash

set -eu
set -o pipefail

usage() {
	echo "Hey queen 👑👋"
	echo "shecan.sh is here to setup shecan for you"
	echo "usage: shecan.sh [-r] [-s] [-h] [-p ip]"
	echo "  -r   reset dns to default"
	echo "  -s   set dns to shecan"
	echo "  -h   display help"
	echo "  -p   shecan dns server ip address"
}

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
	source="${BASH_SOURCE[0]}"
fi

root="$(cd "$(dirname "$(realpath "$source")")/../.." && pwd)"

source "$root/scripts/lib/main.sh"

case "$USER" in
"parham")
	message 'shecan.sh' "Welcome impersonated queen 👑"
	;;
"elahe")
	message 'shecan.sh' "Welcome queen 👑"
	;;
"raha")
	message 'shecan.sh' "Welcome queen 👑"
	;;
*)
	message 'shecan.sh' "This script is not for you, shu shu"
	exit 1
	;;
esac

reset=false
setup=false

# please note that these are the pro address of shecan.
shecan=("178.22.122.101" "185.51.200.1")

while getopts 'rsh:' argv; do
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
	*) ;;
	esac
done

# checks you shecan status
http_code=$(curl -s -o /dev/null -w "%{http_code}" https://check.shecan.ir)
if [ "$http_code" -eq 200 ]; then
	message 'shecan.sh' "you are using shecan"
else
	message 'shecan.sh' "you are not using shecan"
fi

# sets or rests shecan DNS in OSx
if [[ "$OSTYPE" == "darwin"* ]]; then
	if [ "$reset" = true ]; then
		message 'shecan.sh' "resets DNS to DHCP defaults"
		networksetup -setdnsservers Wi-Fi empty
	fi
	if [ "$setup" = true ]; then
		message 'shecan.sh' "sets DNS to shecan ${shecan[*]}"
		networksetup -setdnsservers Wi-Fi "${shecan[@]}"
		curl 'https://ddns.shecan.ir/update?password=f45154507bd7bdd7'
	fi
else
	message 'shecan.sh' "this script just works with OSx" 'error'
fi
