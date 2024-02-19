#!/usr/bin/env bash

set -eu
set -o pipefail

dry_run=0

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
	source="${BASH_SOURCE[0]}"
fi

root="$(cd "$(dirname "$(realpath "$source")")/../.." && pwd)"

source "$root/scripts/lib/main.sh"

case "$USER" in
"parham")
	dry_run=1
	message 'forti.sh' "Welcome impersonated queen 👑"
	;;
"elahe")
	message 'forti.sh' "Welcome queen 👑"
	;;
"raha")
	message 'forti.sh' "Welcome queen 👑"
	;;
*)
	message 'forti.sh' "This script is not for you, shu shu"
	exit 1
	;;
esac

if [[ "${OSTYPE}" == "darwin"* ]]; then
	message 'forti.sh' " darwin, using brew"
	require_brew openconnect age
elif [[ -n "$(command -v pacman)" ]]; then
	message 'forti.sh' " linux with pacman installed, using pacman/yay"

	require_pacman age
fi

if [[ "$dry_run" = 1 ]]; then
	message 'forti.sh' 'encrypt configuration for snapp1 vpn using elahe/raha public key 🔒'
	if [ -f "$root/encrypted/elahe/snapp1.up" ]; then
		age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/snapp1.up" >"$root/encrypted/elahe/snapp1.up.enc"
	fi
	if [ -f "$root/encrypted/elahe/snapp1.conf" ]; then
		age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/snapp1.conf" >"$root/encrypted/elahe/snapp1.conf.enc"
	fi
fi

message 'forti.sh' 'decrypt configuration for snapp1 vpn using elahe/raha public key 🔓'
if [[ "$dry_run" = 1 ]]; then
	if [ -f "$HOME/.ssh/raha_rsa" ]; then
		age -d -i "$HOME/.ssh/raha_rsa" "$root/encrypted/elahe/snapp1.up.enc" >"$root/encrypted/elahe/snapp1.up"
		age -d -i "$HOME/.ssh/raha_rsa" "$root/encrypted/elahe/snapp1.conf.enc" >"$root/encrypted/elahe/snapp1.conf"
	else
		message 'forti.sh' 'please first install the required keys'
	fi
else
	if [ -f "$HOME/.ssh/id_rsa" ]; then
		age -d -i "$HOME/.ssh/id_rsa" "$root/encrypted/elahe/snapp1.up.enc" >"$root/encrypted/elahe/snapp1.up"
		age -d -i "$HOME/.ssh/id_rsa" "$root/encrypted/elahe/snapp1.conf.enc" >"$root/encrypted/elahe/snapp1.conf"
	else
		message 'forti.sh' 'please first install the required keys'
	fi
fi

if [[ "$dry_run" = 1 ]]; then
	message 'forti.sh' 'we are on dry run'
else
	mkdir "$(brew --prefix)/etc/openconnect" || true
	copycat "forti.sh" "encrypted/elahe/snapp1.conf" "$(brew --prefix)/etc/openconnect/snapp1.conf" 0
	copycat "forti.sh" "encrypted/elahe/snapp1.up" "$(brew --prefix)/etc/openconnect/snapp1.up" 0

	sudo tee "/Library/LaunchAgents/com.openconnect.snapp1.plist" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.openconnect.snapp1</string>
  <key>ProgramArguments</key>
  <array>
      <string>/opt/homebrew/bin/openconnect</string>
      <string>--config</string>
      <string>/opt/homebrew/etc/openconnect/snapp1.conf</string>
  </array>
  <key>RunAtLoad</key>
  <false/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardInPath</key>
  <string>/opt/homebrew/etc/openconnect/snapp1.up</string>
  <key>StandardOutPath</key>
  <string>/opt/homebrew/var/log/openconnect.log</string>
  <key>StandardErrorPath</key>
  <string>/opt/homebrew/var/log/openconnect.log</string>
</dict>
</plist>
EOL

	sudo launchctl enable system/com.openconnect.snapp1

	sudo launchctl bootout system /Library/LauchAgents/com.openconnect.snapp1.plist || true
	sudo launchctl bootstrap system /Library/LauchAgents/com.openconnect.snapp1.plist || true
fi
