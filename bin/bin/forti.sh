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

require_brew openconnect age

if [[ "$dry_run" = 1 ]]; then
	message 'forti.sh' 'encrypt configuration for snapp1 vpn using elahe/raha public key 🔒'
	age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/snapp1.up" >"$root/encrypted/elahe/snapp1.conf.enc"
	age -R ~/.ssh/raha_rsa.pub "$root/encrypted/elahe/snapp1.conf" >"$root/encrypted/elahe/snapp1.up.enc"
fi

message 'forti.sh' 'decrypt configuration for snapp1 vpn using elahe/raha public key 🔓'
if [[ "$dry_run" = 1 ]]; then
	age -d -i ~/.ssh/raha_rsa "$root/encrypted/elahe/snapp1.up.enc" >"$root/encrypted/elahe/snapp1.conf"
	age -d -i ~/.ssh/raha_rsa "$root/encrypted/elahe/snapp1.conf.enc" >"$root/encrypted/elahe/snapp1.up"
else
	age -d -i ~/.ssh/id_rsa "$root/encrypted/elahe/snapp1.up.enc" >"$root/encrypted/elahe/snapp1.conf"
	age -d -i ~/.ssh/id_rsa "$root/encrypted/elahe/snapp1.conf.enc" >"$root/encrypted/elahe/snapp1.up"
fi

if [[ "$dry_run" = 1 ]]; then
	message 'forti.sh' 'we are on dry run'
else
	copycat "$root/encrypted/elahe/snapp1.up" "$(brew --prefix)/etc/openconnect/snapp1.conf" 0
	copycat "$root/encrypted/elahe/snapp1.up" "$(brew --prefix)/etc/openconnect/snapp1.up" 0
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

	sudo launchctl bootout system/com.openconnect.snapp1 || true
	sudo launchctl bootstrap system/com.openconnect.snapp1 || true
fi
