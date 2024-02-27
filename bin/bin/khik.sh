#!/bin/bash

set -eu
set -o pipefail

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
	source="${BASH_SOURCE[0]}"
fi

root="$(cd "$(dirname "$(realpath "$source")")/../.." && pwd)"

source "$root/scripts/lib/main.sh"

case "$USER" in
"parham")
	message 'khik.sh' "Welcome impersonated queen 👑"
	;;
"elahe")
	message 'khik.sh' "Welcome queen 👑"
	;;
"raha")
	message 'khik.sh' "Welcome queen 👑"
	;;
*)
	message 'khik.sh' "This script is not for you, shu shu"
	exit 1
	;;
esac

if [[ "${OSTYPE}" == "darwin"* ]]; then
	message 'khik.sh' " darwin, using brew"

	require_brew age wireguard-tools
elif [[ -n "$(command -v pacman)" ]]; then
	message 'khik.sh' " linux with pacman installed, using pacman/yay"

	require_pacman age
fi

if [[ "$USER" = "parham" ]]; then
	message 'khik.sh' 'encrypt configuration for alvani vpn (over wireguard) using elahe/raha public key 🔒'
	if [ -f "$root/encrypted/elahe/sandcrawler.conf" ]; then
		age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/sandcrawler.conf" >"$root/encrypted/elahe/sandcrawler.conf.enc"
	fi

	if [ -f "$root/encrypted/elahe/millennium-falcon.conf" ]; then
		age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/millennium-falcon.conf" >"$root/encrypted/elahe/millennium-falcon.conf.enc"
	fi
fi

message 'forti.sh' 'decrypt configuration for alvani vpn using (over wireguard) elahe/raha public key 🔓'
if [ -f "$HOME/.ssh/raha_rsa" ]; then
	age -d -i "$HOME/.ssh/raha_rsa" "$root/encrypted/elahe/millennium-falcon.conf.enc" >"$root/encrypted/elahe/millennium-falcon.conf"
	age -d -i "$HOME/.ssh/raha_rsa" "$root/encrypted/elahe/sandcrawler.conf.enc" >"$root/encrypted/elahe/sandcrawler.conf"
elif [ -f "$HOME/.ssh/id_rsa" ]; then
	age -d -i "$HOME/.ssh/id_rsa" "$root/encrypted/elahe/millennium-falcon.conf.enc" >"$root/encrypted/elahe/millennium-falcon.conf"
	age -d -i "$HOME/.ssh/id_rsa" "$root/encrypted/elahe/sandcrawler.conf.enc" >"$root/encrypted/elahe/sandcrawler.conf"
else
	message 'khik.sh' 'please first install the required keys'
fi

mkdir "$(brew --prefix)/etc/wireguard" || true
copycat "khik.sh" "encrypted/elahe/$HOSTNAME.conf" "$(brew --prefix)/etc/wireguard/alvani.conf" 0

sudo wg-quick up alvani
