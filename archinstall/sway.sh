#!/bin/bash
set -e

if [[ $USER != parham ]]; then
	echo "you are not my master"
	exit
fi

echo "install mesa-vdpau for better performance on ATI graphic cards"
echo "https://wiki.archlinux.org/title/Improving_performance"

# echo "because of iran sanctions maybe you need ghermezi for downloading from github"
# cd "$HOME/dotfiles/" && ./start.sh v2ray
# sudo vim /etc/v2ray/config.json
# sudo systemctl enable --now v2ray

# global variable that points to dotfiles root directory
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME/yay-bin" && makepkg -si

echo "lets use greetd as dm, so wait for r...ust"
cd "$HOME/dotfiles/" && ./start.sh rust
yay -Syu --needed --noconfirm greetd greetd-tuigreet-bin

sudo cp "$current_dir/sway.d/sway.sh" /usr/local/bin/sway.sh
sudo cp "$current_dir/sway.d/sway.desktop" /usr/share/wayland-sessions/sway.desktop
sudo cp "$current_dir/sway.d/greetd" /etc/pam.d/greetd
sudo cp "$current_dir/sway.d/config.toml" /etc/greetd/config.toml

sudo systemctl enable greetd.service

echo "have fun with your sway"
cd "$HOME/dotfiles/" && ./start.sh sway
sudo pacman -Syu --needed --noconfirm firefox
