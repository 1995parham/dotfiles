#!/bin/bash
set -e

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

# global variable that points to `dotfiles/archinstall` root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/lib/message.sh
source "$current_dir/../scripts/lib/message.sh"
# shellcheck source=scripts/lib/require.sh
source "$current_dir/../scripts/lib/require.sh"

# install yay to have yay for installing from
cd "$current_dir/.." && ./start.sh go
cd "$current_dir/.." && ./start.sh yay

message "archinstall" "lets use greetd as desktop manager, so wait for rust"
cd "$current_dir/.." && ./start.sh rust
require_aur greetd greetd-tuigreet-bin

sudo cp "$current_dir/wayland.d/greetd" /etc/pam.d/greetd
sudo cp "$current_dir/wayland.d/config.toml" /etc/greetd/config.toml

message "archinstall" "enable greetd"
sudo systemctl enable greetd.service

message "archinstall" "setup sway and required softwares"
cd "$current_dir/.." && ./start.sh sway

sudo cp "$current_dir/sway.d/sway.sh" /usr/local/bin/sway.sh
sudo cp "$current_dir/sway.d/sway.desktop" /usr/share/wayland-sessions/sway.desktop
